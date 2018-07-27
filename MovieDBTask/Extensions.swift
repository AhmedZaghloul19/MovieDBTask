//
//  Extensions.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/9/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import Foundation
import UIKit

let SERVICE_URL_PREFIX = "http://api.themoviedb.org/3/"
let MOVIE_DB_API_KEY = "2696829a81b1b5827d515ff121700838"
let URL_IMAGE_PREFIX = "http://image.tmdb.org/t/p/w[w]"

let userData = UserDefaults.standard

extension UIView{
    func dropShadow(scale: Bool = true) {
        DispatchQueue.main.async {
            self.layer.masksToBounds = false
            self.layer.shadowColor = UIColor.black.cgColor
            self.layer.shadowOpacity = 0.3
            self.layer.shadowOffset = CGSize(width: 0, height: 1)
            self.layer.shadowRadius = 1.5
            self.layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = scale ? UIScreen.main.scale : 1
        }
    }
}
extension UITableView {
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.tableFooterView = UIView()
    }
}

enum ImageSizesLevel:Int {
    case low = 92
    case medium = 185
    case high = 500
    case vHigh = 780
}

enum VendingMachineError:Error {
    case valueNotFounds
}

extension NSDictionary {
    func getValueForKey<T>(key:String,callback:T)  -> T{
        guard let value  = self[key] as? T else{
            return callback}
        return value
    }
    func getValueForKey<T>(key:String) throws -> T{
        guard let value  = self[key] as? T else{throw VendingMachineError.valueNotFounds}
        return value
    }
}

extension NSMutableURLRequest{
    //to be expandable when adding authorization
    func setBodyConfigrationWithMethod(method:String){
        self.httpMethod = method
    }
}

let appDark = UIColor(red: 63/255, green: 63/255, blue: 63/255, alpha: 1.0)
let appGray = UIColor(red: 231/255, green: 234/255, blue: 236/255, alpha: 1.0)

protocol SortingDelegate :class {
    func didSelectItemToSortWith(ItemIndex index:Int)
    func sortViewDidDismissed()
}

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    @IBAction func reload(){
        self.viewDidLoad()
    }
}

