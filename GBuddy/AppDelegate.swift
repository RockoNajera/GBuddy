//
//  AppDelegate.swift
//  GBuddy
//
//  Created by Rodrigo Nájera Rivas on 5/5/17.
//  Copyright © 2017 Yooko. All rights reserved.
//

import UIKit
import Firebase



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FIRApp.configure()
        
        FIRDatabase.database().persistenceEnabled = true
        
        return true
    }

}

