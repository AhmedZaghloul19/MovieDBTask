//
//  AppDelegate.swift
//  MovieDBTask
//
//  Created by Ahmed Zaghloul on 7/23/18.
//  Copyright © 2018 AhmedZaghloul. All rights reserved.
//

import UIKit
import Kingfisher

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //Handling Images Cache to handle when to be deleted 
        // 200 MB
        ImageCache.default.maxDiskCacheSize = UInt(200 * 1024 * 1024)
        // 3 days
        ImageCache.default.maxCachePeriodInSecond = TimeInterval(60 * 60 * 24 * 3)

        return true
    }
}

