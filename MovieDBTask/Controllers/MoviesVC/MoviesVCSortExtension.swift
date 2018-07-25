//
//  MoviesVCSortExtension.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/23/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit

extension MoviesVC :SortingDelegate{
    @IBAction func addBottomSheetViewForSorting() {
        if bottomSheetVC == nil{
            bottomSheetVC = FilterVC()
            bottomSheetVC?.selectedSortIndex = self.selectedSortIndex
            self.addChildViewController(bottomSheetVC!)
            self.view.addSubview(bottomSheetVC!.view)
            bottomSheetVC!.didMove(toParentViewController: self)
            bottomSheetVC!.delegate = self
        }
    }
    
    func didSelectItemToSortWith(ItemIndex index: Int) {
        self.selectedSortIndex = index
        switch index {
        case 0://by rating
            sortedMovies = movies.sorted(by: { $0.vote_average! < $1.vote_average! })
        case 1://by popularity
            sortedMovies = movies.sorted(by: { $0.popularity! > $1.popularity! })
        case 2://by vote count
            sortedMovies = movies.sorted(by: { $0.vote_count! > $1.vote_count! })
        default:
            sortedMovies.removeAll()
        }
        
        DispatchQueue.main.async {
            UIView.transition(with: self.collectionView,
                              duration: 0.35,
                              options: .transitionCrossDissolve,
                              animations: { self.collectionView.reloadData() })
        }
    }
    
    func sortViewDidDismissed() {
        self.bottomSheetVC = nil
    }
}
