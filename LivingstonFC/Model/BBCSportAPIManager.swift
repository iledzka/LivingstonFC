//
//  BBCSportAPIManager.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 20/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit
import SwiftyJSON

//API used to fetch news for the Newsfeed page.
class BBCSportAPIManager: NSObject {
    let apiKey = "e21de5ee495740e7b74f01e526826260"
    var baseURL: String { return "https://newsapi.org/v2/everything?q=Livingston&sources=bbc-sport&apiKey=" + apiKey }
    static let sharedInstance = BBCSportAPIManager()
    
    public func getNews(onSuccess: @escaping([BBCNewsArticle]) -> Void, onFailure: @escaping(Error) -> Void){
        let url : String = baseURL
        let request: NSMutableURLRequest = NSMutableURLRequest(url: NSURL(string: url)! as URL)
        request.httpMethod = "GET"
        let session = URLSession.shared
        let task = session.dataTask(with: request as URLRequest, completionHandler: {data, response, error -> Void in
            if(error != nil){
                onFailure(error!)
            } else{
                let result = try! JSON(data: data!)
                var news = [BBCNewsArticle]()
                if let articles = result.dictionary {
                    guard !articles.isEmpty else { print("Didn't find any articles!"); return }
                    
                    for (_, object) in articles["articles"]!{
                        print(object.dictionaryObject!)
                        if let article = BBCNewsArticle(data: object.dictionaryObject! as NSDictionary) {
                            news.append(article)
                        }
                    }
                }
                onSuccess(news)
            }
        })
        task.resume()
    }
}
