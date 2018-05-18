//
//  Community.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 06/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation
import UIKit

//  Model class Community is used to store data fetched from Livingston FC API. This class represents data
//  about events organised by Livingston Club.
class Community {
    let id: String
    let name: String
    let imageUri: String
    let description: String
    let link: String
    
    init?(data: NSDictionary?){
        guard
            let id = data?.value(forKey: "id") as? Int,
            let name = data?.value(forKey: "name") as? String,
            let imageUri = data?.value(forKey: "image") as? String,
            let description = data?.value(forKey: "description") as? String,
            let link = data?.value(forKey: "eventUrl") as? String
            else { return nil }
        
        self.id = String(id)
        self.name = name
        self.imageUri = imageUri
        self.description = description
        self.link = link
    }
    
}
