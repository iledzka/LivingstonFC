//
//  CommunityItemViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 06/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  Community view
class CommunityItemViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.linkToWebsiteButton.layer.cornerRadius = 10
        self.titleLabel.text = event?.name
        self.descriptionLabel.text = event?.description
        let url = LivingstonFCAPIManager.sharedInstance.baseURL + (event?.imageUri)!
        if let imgUrl = URL(string: url) {
            loadImage(from: imgUrl) {
                let width = UIScreen.main.bounds.size.width
                self.image.image = $0.resizeImage(CGFloat(width), opaque: true)
            }
        }
        
    }
    
    @IBOutlet weak var linkToWebsiteButton: UIButton!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    var event: Community?
    
    @IBAction func loadUrlEvent(_ sender: Any) {
        if let urlString = event?.link, let url = URL(string: urlString) {
            UIApplication.shared.open(url, options: [:], completionHandler: { (status) in
                
            })
        }
    }
}

//  This extension is used to resize the image fetched from api, so it fits the screen
extension UIImage {
    func resizeImage(_ dimension: CGFloat, opaque: Bool, contentMode: UIViewContentMode = .scaleAspectFit) -> UIImage {
        var width: CGFloat
        var height: CGFloat
        var newImage: UIImage
        
        let size = self.size
        let aspectRatio =  size.width/size.height
        
        switch contentMode {
        case .scaleAspectFit:
            if aspectRatio > 1 {                            // Landscape image
                width = dimension
                height = dimension / aspectRatio
            } else {                                        // Portrait image
                height = dimension
                width = dimension * aspectRatio
            }
            
        default:
            fatalError("UIIMage.resizeToFit(): FATAL: Unimplemented ContentMode")
        }
        
        if #available(iOS 10.0, *) {
            let renderFormat = UIGraphicsImageRendererFormat.default()
            renderFormat.opaque = opaque
            let renderer = UIGraphicsImageRenderer(size: CGSize(width: width, height: height), format: renderFormat)
            newImage = renderer.image {
                (context) in
                self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(CGSize(width: width, height: height), opaque, 0)
            self.draw(in: CGRect(x: 0, y: 0, width: width, height: height))
            newImage = UIGraphicsGetImageFromCurrentImageContext()!
            UIGraphicsEndImageContext()
        }
        
        return newImage
    }
}
