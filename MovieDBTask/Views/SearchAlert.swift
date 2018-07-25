//
//  SearchAlert.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/24/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit

class SearchAlert: UIView {
  
  let label: UILabel = UILabel()
  
  override public init(frame: CGRect) {
    super.init(frame: frame)
    configureView()
  }
  
  required public init?(coder: NSCoder) {
    super.init(coder: coder)
    configureView()
  }
  
  func configureView() {
//    backgroundColor = appColor
    alpha = 0.0
    
    // Configure label
    label.textAlignment = .center
    label.textColor = UIColor.black
    addSubview(label)
  }
  
  override func draw(_ rect: CGRect) {
    label.frame = bounds
  }
  
  //MARK: - Animation
  
  @objc fileprivate func hideAlert() {
    UIView.animate(withDuration: 0.7) {[unowned self] in
      self.alpha = 0.0
    }
  }
  
  fileprivate func showAlert() {
    UIView.animate(withDuration: 0.7, animations: {
        self.alpha = 1.0
    }) { (_) in
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.hideAlert()
        }
    }
  }
}

extension SearchAlert {
  //MARK: - Public API
  
  public func setNotFiltering() {
    label.text = ""
    hideAlert()
  }
  
  public func setIsFilteringToShow(filteredItemCount: Int) {
    if (filteredItemCount == 0) {
      label.text = "No items match your query"
      showAlert()
    }else{
        self.setNotFiltering()
    }
  }

}
