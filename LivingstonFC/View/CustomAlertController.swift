//
//  CustomAlertController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 11/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  This struct is used to create custom alerts that can feedback information to the user
struct CustomAlert {

    //  This alert is showed only to partial members.
    //  The content displayed in PlayerProfileViewController and Players' stats are restricted to these users.
    static let contentRestrictionAlert: UIAlertController = {
        let alert = UIAlertController(title: "Content Not Available", message: "Upgrade to Full Membership to see this content.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
        return alert
    }()
    
    //  Inform user about lost connection
    static let offlineAlert: UIAlertController = {
        let alert = UIAlertController(title: "No internet connection", message: "Please connect to the internet to view the content.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
        return alert
    }()
    
    //  Unsuccessful login alert
    static func unsuccessfulLogin(_ errorMsg: String)-> UIAlertController {
        let alert = UIAlertController(title: "Could Not Connect", message: errorMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        alert.view.tintColor = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
        return alert
    }
}
