//
//  BBCNewsTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 22/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

let imageSession = URLSession(configuration: .ephemeral)

let cache = NSCache<NSURL, UIImage>()

func loadImage(from url: URL, completion: @escaping (UIImage) -> Void){
    if let image = cache.object(forKey: url as NSURL){
        completion(image)
    } else {
        let task = imageSession.dataTask(with: url) { (imageData, _, _) in
            guard let imageData = imageData,
                let image = UIImage(data: imageData)
                else { return }
            //  cache the images for smooth scrolling
            cache.setObject(image, forKey: url as NSURL)
            DispatchQueue.main.async {
                completion(image)
            }
            
        }
        task.resume()
    }
}


//  This class is used to configue a single cell containing bbc sport news article
//  Used in second section of NewsfeedViewController
class BBCNewsTableViewCell: UITableViewCell {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView! {
        didSet {
              spinner.centerYAnchor.constraint(equalTo: newsImage.centerYAnchor).isActive = true
              spinner.startAnimating()
              spinner.hidesWhenStopped = true
        }
    }
    
    @IBOutlet weak var newsImage: UIImageView!
    
    @IBOutlet weak var newsTitle: UILabel!
    
    @IBOutlet weak var newsDate: UILabel!
    
    var newsArticle: BBCNewsArticle? {
        didSet {
            updateUI()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        newsImage.image = UIImage(named: "news_placeholder")
        newsTitle.text = nil
        newsDate.text = nil
    }
    
    private func updateUI(){
        newsTitle.text = newsArticle?.title
        
        let currentTitle = self.newsTitle.text
        if let imageURL = newsArticle?.imageUrl {
            loadImage(from: imageURL) {
                guard currentTitle == self.newsTitle.text else { return }
                self.newsImage?.image = $0
                self.spinner.stopAnimating()
            }
        } else {
            newsImage?.image = nil
        }
            if let date = newsArticle?.date {
                let formatter = DateFormatter()
                if Date().timeIntervalSince(date) > 24*60*60 {
                    formatter.dateStyle = .medium
                } else {
                    formatter.timeStyle = .medium
                }
                newsDate?.text = formatter.string(from: date)
            } else {
                newsDate?.text = nil
            }
        
    }
}
