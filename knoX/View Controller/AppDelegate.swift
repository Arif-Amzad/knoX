//
//  AppDelegate.swift
//  knoX
//
//  Created by Arif Amzad on 2/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

@UIApplicationMain

class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        Database.database().isPersistenceEnabled = true
        setRootViewController()
        
        
        
        
        return true
    }
    
    
    func setRootViewController() {
        
        if Auth.auth().currentUser != nil {
            
            print("-----U---S---E---R---------E---X---I---S---T------ ")
            ///newlyadded start
            window = UIWindow()
            window?.makeKeyAndVisible()
            
            //window?.rootViewController = UINavigationController(rootViewController: ChatViewController())
            
            //newlyadded end
            
            // switch root view controllers
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "RunningChatListViewControllerID")

            self.window?.rootViewController = nav
            

            //var navigationItem = UINavigationItem()
            //navigationItem.title = "new Title"
        }
        else {
            
            print("-----N---O--------U---S---E---R------ ")
            
            // switch back to view controller 1
            let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
            let nav = storyboard.instantiateViewController(withIdentifier: "WelcomeViewControllerID")
            
            self.window?.rootViewController = nav
        }
    }
    


    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

