//
//  AppDelegate.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 19/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        customiseUI()
        
        //  Check whether user is loggen in. If not, Switcher will initialise LoginViewController
        Switcher.updateRootVC()
        return true
    }

    private func customiseUI() {
        //set colour theme for navigationbar and tab bar
        UINavigationBar.appearance().barTintColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        UINavigationBar.appearance().tintColor = UIColor.black
        UITabBar.appearance().barTintColor = UIColor(red: 255/255, green: 204/255, blue: 0/255, alpha: 1)
        //selected item colour
        UITabBar.appearance().tintColor = UIColor.white
        UITabBar.appearance().unselectedItemTintColor = UIColor.black
        
        
    }
}

