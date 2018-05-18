//
//  LogoutViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 09/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  Log out view controller.
class LogoutViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Log Out"
        if (UserDefaultsManager.isLoggedIn()){
            //  Remove all persistent data
            UserDefaultsManager.logOut()
            //  Go to login page
            Switcher.updateRootVC()
        }
    }

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        spinner.startAnimating()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        spinner.stopAnimating()
    }
}
