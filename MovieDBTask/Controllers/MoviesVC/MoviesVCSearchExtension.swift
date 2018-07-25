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
        self.pageNo = 1
        self.getData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.searchText = searchText
        if(searchText.isEmpty){
            //reload your data source if necessary
            self.movies.removeAll()
            self.sortedMovies.removeAll()
            self.endLoadingAnimation()
        }
    }
    
}
