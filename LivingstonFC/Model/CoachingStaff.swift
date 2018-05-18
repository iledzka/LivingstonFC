//
//  CoachingStaff.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 06/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation
import UIKit

//  Model class CoachingStaff is used to store data from Livingston FC API that represents the Coaching Staff
//  from the Club.
class CoachingStaff {
    let id: String
    let firstName: String
    let lastName: String
    let position: String
    let imageUri: String
    let team: String
    
    init?(data: NSDictionary?){
        guard
            let id = data?.value(forKey: "id") as? Int,
            let firstName = data?.value(forKey: "firstName") as? String,
            let lastName = data?.value(forKey: "lastName") as? String,
            let position = data?.value(forKey: "position") as? String,
            let imageUri = data?.value(forKey: "imageIconUrl") as? String,
            let team = data?.value(forKey: "team") as? String
            else { return nil }
        
        self.id = String(id)
        self.firstName = firstName
        self.lastName = lastName
        self.position = position
        self.imageUri = imageUri
        self.team = team
    }
    
}
