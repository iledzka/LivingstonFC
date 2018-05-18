//
//  BBCNewsArticle.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 20/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import Foundation
import UIKit

//  Model class BBCNewsArticle is used to store data fetched from BBC Sport News.
class BBCNewsArticle: CustomStringConvertible {
    public let title: String
    public let date: Date
    public let imageUrl: URL
    public let url: URL
    
    public var description: String { return "Article title: \(title), date: \(date), image url: \(imageUrl), link: \(url)" }
    
    // MARK: - Internal Implementation
    
    init?(data: NSDictionary?)
    {
        guard
            let title = data?.value(forKey: "title") as? String,
            let date = dateFormatter.date(from: data?.value(forKey: "publishedAt") as? String ?? ""),
            let image = data?.value(forKey: "urlToImage") as? String,
            let url = data?.value(forKeyPath: "url") as? String
            else {
                return nil
        }
        
        self.title = title
        self.date = date
        self.imageUrl = URL(string: image)!
        self.url = URL(string: url)!
    }
}

    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
