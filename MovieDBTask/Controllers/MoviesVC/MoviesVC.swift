//
//  ViewController.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/23/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit

class MoviesVC: BaseViewController {

    @IBOutlet weak var collectionView:UICollectionView!
    @IBOutlet weak var searchGuideTableView:UITableView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var searchAlert: SearchAlert!
    
    var bottomSheetVC :FilterVC? = nil
    var movies :[Movie] = []
    var sortedMovies = [Movie]()
    var recentSearchKeywords:[String] = []
    var filteredSearchKeywords:[String] = []
    var selectedSortIndex = 3
    var pageNo = 1
    var maxPages = 1
    var refreshControl: UIRefreshControl!
    var searchText = ""
    var searchHeaderIndex :IndexPath!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.constructRefreshControl()
        self.hideKeyboardWhenTappedAround()
        self.recentSearchKeywords = (userData.value(forKey: "recent_keywords") as? [String]) ?? []

    }
    
    override func getData() {
        super.getData()
        if !self.searchText.isEmpty {
            RequestManager.defaultManager.getMoviesWith(Keyword: "\(searchText)", pageNo: pageNo) { (error, movies, numberOfPages) in
                if !error {
                    self.sortedMovies.removeAll()
                    self.selectedSortIndex = 3
                    self.movies = self.pageNo == 0 ? movies! : self.movies + movies!
                    self.maxPages = numberOfPages!
                    if !self.searchText.isEmpty && movies!.count > 0 {
                        self.addToRecents()
                    }
                }else{
                    DispatchQueue.main.async {
                        self.errorView.isHidden = false
                    }
                }
                self.endLoadingAnimation()
            }
        }else{
            endLoadingAnimation()
        }
    }
    
    override func beginLoadingAnimation() {
        DispatchQueue.main.async {
//            self.refreshControl.beginRefreshing()
            self.activityIndicator.startAnimating()
        }
    }
    
    override func endLoadingAnimation() {
        DispatchQueue.main.async {
            self.activityIndicator.stopAnimating()
            self.refreshControl.endRefreshing()
            self.collectionView.reloadData()
            if !self.searchText.isEmpty {
                self.searchAlert.setIsFilteringToShow(filteredItemCount: self.movies.count)
            }
        }
    }
    
    func addToRecents() {
        if let foundedIndex = self.recentSearchKeywords.index(of: self.searchText) {
            self.recentSearchKeywords.remove(at: foundedIndex)
        }else if recentSearchKeywords.count >= 10 {
            self.recentSearchKeywords.removeLast()
        }
        self.recentSearchKeywords.insert(self.searchText, at: 0)
        userData.set(self.recentSearchKeywords, forKey: "recent_keywords")
    }
    
    fileprivate func constructRefreshControl() {
        self.collectionView!.alwaysBounceVertical = true
        refreshControl = UIRefreshControl()
        let attributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        refreshControl.attributedTitle = NSAttributedString(string: "Scroll down to Refresh", attributes: attributes)
        refreshControl.tintColor = .white
        
        refreshControl.addTarget(self, action: #selector(refresh), for: UIControlEvents.valueChanged)
        collectionView.addSubview(refreshControl)
    }
    
    @IBAction func refresh(sender:AnyObject) {
        self.resetAll()
        getData()
    }
    
    func resetAll() {
        self.pageNo = 1
        self.movies.removeAll()
        self.sortedMovies.removeAll()
        self.collectionView.reloadData()
    }
    
    func searchSampleTapped(sender:String){
        searchText = sender
        let headerView:CollectionHeaderView = collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: self.searchHeaderIndex) as! CollectionHeaderView
        
        headerView.searchBar.text = searchText
        self.resetAll()
        getData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieDetailsVC, let movie = sender as? Movie {
            vc.movie = movie
        }
    }
}

