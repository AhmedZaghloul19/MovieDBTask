//
//  MovieCell.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/23/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit
import Kingfisher

class MovieCell: UICollectionViewCell {

    @IBOutlet weak var posterImageView:UIImageView!
    @IBOutlet weak var titleLabel:UILabel!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var ratingLabel:UILabel!
    @IBOutlet weak var voteCountLabel:UILabel!
    @IBOutlet weak var dataHolderView:UIView!
    
    var movie: Movie!{
        didSet{
            self.setData()
        }
    }
    
    private func setData() {
        let url = URL(string: URL_IMAGE_PREFIX.replacingOccurrences(of: "[w]", with: "\(ImageSizesLevel.medium.rawValue)") + movie.poster_path!)
        posterImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "movie"), options: [.transition(ImageTransition.fade(1))], progressBlock: { receivedSize, totalSize in
        }, completionHandler: { image, error, cacheType, imageURL in
        })
        self.titleLabel.text = self.movie.title!
        self.dateLabel.text = self.movie.release_date!
        self.ratingLabel.text = "\(self.movie.vote_average!)"
        self.voteCountLabel.text = "\(self.movie.vote_count!)"
    }
    
    override func draw(_ rect: CGRect) {
        self.gradientHolderView()
        self.dropShadow()
    }
    
    fileprivate func gradientHolderView() {
        var colors = [CGColor]()
        colors.append(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 1).cgColor)
        colors.append(UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0).cgColor)
        
        let gradient = CAGradientLayer()
        gradient.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.dataHolderView.frame.height)
        gradient.colors = colors
        gradient.startPoint = CGPoint(x: 0, y: 1)
        gradient.endPoint = CGPoint(x: 0, y: 0)
        self.dataHolderView.layer.insertSublayer(gradient, at: 0)
    }

}
