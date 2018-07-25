//
//  FilterVC.swift
//  CarsList
//
//  Created by Ahmed Zaghloul on 7/9/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit

class FilterVC: UIViewController {

    @IBOutlet weak var tableView:UITableView!
    weak var delegate:SortingDelegate?
    
    var selectedSortIndex = 3
    let filters = ["Rating" , "Popularity", "Vote Counter", "Default"]
    
    var fullView: CGFloat {
        return UIScreen.main.bounds.height - (UIScreen.main.bounds.height * 0.60)
    }
    var partialView: CGFloat {
        return UIScreen.main.bounds.height - (UIScreen.main.bounds.height * 0.32)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let height = UIScreen.main.bounds.height
        let width  = UIScreen.main.bounds.width
        view.frame = CGRect(x: 0, y: self.view.frame.maxY, width: width, height: height)

        if #available(iOS 11.0, *) {
            tableView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "ChoiceCell")
        
        let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(FilterVC.panGesture))
        view.addGestureRecognizer(gesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.6, animations: { [weak self] in
                let frame = self?.view.frame
                let yComponent = self?.partialView
                self?.view.frame = CGRect(x: 0, y: yComponent!, width: frame!.width, height: frame!.height)
            })
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        delegate?.sortViewDidDismissed()
    }

    @objc private func panGesture(_ recognizer: UIPanGestureRecognizer) {
        
        let translation = recognizer.translation(in: self.view)
        let velocity = recognizer.velocity(in: self.view)
        
        let y = self.view.frame.minY
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
        recognizer.setTranslation(CGPoint.zero, in: self.view)
        
        if recognizer.state == .ended {
            var duration =  velocity.y < 0 ? Double((y - fullView) / -velocity.y) : Double((partialView - y) / velocity.y )
            
            duration = duration > 1.3 ? 1 : duration
            
            UIView.animate(withDuration: duration, delay: 0.0, options: [.allowUserInteraction], animations: {
                print(velocity.y)
                if  velocity.y >= 0  {
                    if y <= (self.partialView){
                        self.view.frame = CGRect(x: 0, y: self.partialView, width: self.view.frame.width, height: self.view.frame.height)
                    }
                } else {
                    self.view.frame = CGRect(x: 0, y: self.fullView, width: self.view.frame.width, height: self.view.frame.height)
                }
                
            }, completion: { [weak self] _ in
                if y >= (self?.partialView)!  {
                    UIView.animate(withDuration: duration, animations: {
                        self?.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: (self?.view.frame.width)!, height: (self?.view.frame.height)!)
                    }, completion: { (_) in
                        self?.view.removeFromSuperview()
                    })
                }
            })
        }
    }
}

extension FilterVC:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChoiceCell", for: indexPath)
        cell.tintColor = appGray
        cell.textLabel?.text = filters[indexPath.row]
        cell.textLabel?.textColor = appGray
        cell.backgroundColor = .clear
        cell.textLabel?.font = UIFont(name: "System", size: 15)
        
        cell.accessoryType = indexPath.row == selectedSortIndex ? .checkmark : .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSortIndex = indexPath.row
        self.tableView.reloadData()
        self.delegate?.didSelectItemToSortWith(ItemIndex: indexPath.row)
        UIView.animate(withDuration: 1, animations: {
            self.view.frame = CGRect(x: 0, y: UIScreen.main.bounds.height, width: (self.view.frame.width), height: (self.view.frame.height))
        }, completion: { (_) in
            self.view.removeFromSuperview()
        })
    }
}
