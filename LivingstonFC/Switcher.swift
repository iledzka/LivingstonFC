//
//  Switcher.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 09/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation
import UIKit

//  This class is used to manage login/logout process
class Switcher {
    
    static func updateRootVC(){
        
        let status = UserDefaultsManager.isLoggedIn()
        var rootVC : UIViewController?
        
        //  user is logged in - go to Newsfeed
        if(status == true){
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TabBarViewController") as! TabBarViewController
        }else{
            //  user isn't logged in - show login page
            rootVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "Login") as! LoginViewController
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
        
        //remove edit button and style moreNavigationController
        if let tabBarController = appDelegate.window?.rootViewController as? UITabBarController {
            tabBarController.customizableViewControllers = nil
            //var moreNavBar = tabBarController.moreNavigationController.navigationBar
            var moreTableView = tabBarController.moreNavigationController.topViewController?.view
            moreTableView = UITableView.init(frame: CGRect.zero, style: .grouped)
            moreTableView?.backgroundColor = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
            appDelegate.window?.addSubview(moreTableView!)
            appDelegate.window?.makeKeyAndVisible()
        }
    }
}
