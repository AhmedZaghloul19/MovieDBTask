//
//  MoviesVCSearchExtension.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/24/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit

extension MoviesVC:UISearchBarDelegate,UITextFieldDelegate{
    //MARK: - SEARCH
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchText = searchBar.text!
        self.resetAll()
        self.getData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        self.filteredSearchKeywords.removeAll()
        if(searchText.isEmpty){
            self.movies.removeAll()
            self.sortedMovies.removeAll()
            self.endLoadingAnimation()
            self.searchGuideTableView.reloadData()
        }else{
            self.filteredSearchKeywords = self.recentSearchKeywords.filter({return $0.lowercased().range(of: searchText,options:.caseInsensitive,range:nil,locale:nil) != nil})
            self.searchGuideTableView.reloadData()
        }
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        DispatchQueue.main.async {
            self.searchGuideTableView.isHidden = false
        }
        return true
    }
    
    func searchBarShouldEndEditing(_ searchBar: UISearchBar) -> Bool {
        DispatchQueue.main.async {
           self.searchGuideTableView.isHidden = true
        }
        return true
    }
}

//MARK: - TableView Delegate and DataSource
extension MoviesVC :UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredSearchKeywords.count == 0 ? recentSearchKeywords.count : filteredSearchKeywords.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SuggestionCell", for: indexPath)
        let suggestion = filteredSearchKeywords.count == 0 ? recentSearchKeywords[indexPath.item] : filteredSearchKeywords[indexPath.item]
        cell.textLabel?.text = suggestion
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = RecentSearchesHeaderView()
        header.titleLabel.text = "Recent Searches"
        
        return header
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let suggestion = filteredSearchKeywords.count == 0 ? recentSearchKeywords[indexPath.item] : filteredSearchKeywords[indexPath.item]
        self.searchSampleTapped(sender: suggestion)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        if filteredSearchKeywords.count == 0 {
            let deleteAction = UITableViewRowAction(style: .destructive, title: "Delete") { (action, index) in
                self.searchGuideTableView.beginUpdates()
                self.recentSearchKeywords.remove(at: indexPath.row)
                self.searchGuideTableView.deleteRows(at: [indexPath], with: .automatic)
                self.searchGuideTableView.endUpdates()
                userData.set(self.recentSearchKeywords, forKey: "recent_keywords")
            }
            deleteAction.backgroundColor = .red
            return [deleteAction]
        }
        return []
    }
    
}
