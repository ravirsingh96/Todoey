//
//  AppDelegate.swift
//  Todoey
//
//  Created by ravi singh on 05/01/19.
//  Copyright © 2019 ravi singh. All rights reserved.
//

import UIKit
import RealmSwift
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
      //   print(Realm.Configuration.defaultConfiguration.fileURL)
        
      
        
        do {
            _ = try Realm ()
            
        } catch {
            print("Error fetching \(error)")
        }
        
        return true
    }

}

