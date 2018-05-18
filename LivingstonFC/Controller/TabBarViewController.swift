//
//  TabBarViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 27/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        
        //  Custom more icon. This tab is generated automatically, so in order to change its appearance, it has to be overriden.
        let moreIcon = UIImage(imageLiteralResourceName: "more_icon@2")
        self.moreNavigationController.tabBarItem = UITabBarItem(title: nil, image: moreIcon, selectedImage: nil)
        self.moreNavigationController.tabBarItem.imageInsets = UIEdgeInsets(top: 6, left: -6, bottom: -6, right: 6 )
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let moreNavController = self.moreNavigationController
        if let moreTableView = moreNavController.topViewController?.view as? UITableView {
            for cell in moreTableView.visibleCells {
                if cell.textLabel?.text == "Log Out" {
                    cell.backgroundColor = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
                    cell.accessoryType = .none
                }
            }
        }
    }
}
