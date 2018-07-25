//
//  MovieDetailsVC.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/23/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit
import Kingfisher

class MovieDetailsVC: BaseViewController {

    @IBOutlet weak var posterImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var descriptionLabel:UILabel!
    @IBOutlet weak var ratingLabel:UILabel!
    @IBOutlet weak var voteCountLabel:UILabel!
    
    var movie: Movie!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.setData()
        }
    }
    
    func setData() {
        let url = URL(string: URL_IMAGE_PREFIX.replacingOccurrences(of: "[w]", with: "\(ImageSizesLevel.vHigh.rawValue)") + movie.poster_path!)
        posterImageView.kf.indicatorType = .activity
        posterImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "movie"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
        })
        self.titleLabel.text = self.movie.title!
        self.dateLabel.text = self.movie.release_date!
        self.ratingLabel.text = "\(self.movie.vote_average!)"
        self.voteCountLabel.text = "\(self.movie.vote_count!)"
        self.descriptionLabel.text = self.movie.overview!
    }

}
