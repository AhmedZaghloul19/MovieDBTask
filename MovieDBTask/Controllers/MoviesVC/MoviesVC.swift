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
    @IBOutlet weak var searchGuideView:UIView!
    @IBOutlet weak var activityIndicator:UIActivityIndicatorView!
    @IBOutlet weak var searchAlert: SearchAlert!
    
    var bottomSheetVC :FilterVC? = nil
    var movies :[Movie] = []
    var sortedMovies = [Movie]()
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
    }
    
    override func getData() {
        super.getData()
        RequestManager.defaultManager.getMoviesWith(Keyword: "\(searchText)", pageNo: pageNo) { (error, movies, numberOfPages) in
            if !error {
                self.sortedMovies.removeAll()
                self.selectedSortIndex = 3
                self.movies = self.pageNo == 0 ? movies! : self.movies + movies!
                self.maxPages = numberOfPages!
            }else{
                DispatchQueue.main.async {
                    self.errorView.isHidden = false
                }
            }
            self.endLoadingAnimation()
        }
    }
    
    override func beginLoadingAnimation() {
        DispatchQueue.main.async {
            self.refreshControl.beginRefreshing()
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
            self.searchGuideView.isHidden = self.movies.count != 0
        }
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
        self.pageNo = 1
        self.movies.removeAll()
        self.sortedMovies.removeAll()
        self.collectionView.reloadData()
        
        getData()
    }
    
    @IBAction func searchSampleTapped(_ sender:UIButton){
        searchText = sender.currentTitle!
        let headerView:CollectionHeaderView = collectionView.supplementaryView(forElementKind: UICollectionElementKindSectionHeader, at: self.searchHeaderIndex) as! CollectionHeaderView
        
        headerView.searchBar.text = searchText
        getData()
    }
}

extension MoviesVC:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return sortedMovies.count == 0 ? movies.count : sortedMovies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "MovieCell", for: indexPath) as! MovieCell
        let movie = sortedMovies.count == 0 ? movies[indexPath.item] : sortedMovies[indexPath.item]

        cell.movie = movie
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.width - 30)/2, height: (collectionView.frame.height - 40)/3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = sortedMovies.count == 0 ? movies[indexPath.item] : sortedMovies[indexPath.item]

        self.performSegue(withIdentifier: "showMovieDetails", sender: movie)
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.item == self.movies.count - 1 && self.pageNo < self.maxPages{
            self.pageNo += 1
            self.getData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? MovieDetailsVC, let movie = sender as? Movie {
            vc.movie = movie
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView:CollectionHeaderView =  collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "SearchHeader", for: indexPath) as! CollectionHeaderView
            self.searchHeaderIndex = indexPath
            return headerView
        }
        
        return UICollectionReusableView()

    }
}

