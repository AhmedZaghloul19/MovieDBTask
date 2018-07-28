//
//  MoviesVCCollectionViewExtension.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/27/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit

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
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40.0
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

