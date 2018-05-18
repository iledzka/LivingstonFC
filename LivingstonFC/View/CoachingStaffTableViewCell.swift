//
//  CoachingStaffTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 06/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class CoachingStaffTableViewCell: UITableViewCell {

    @IBOutlet weak var coachNameLabel: UILabel!
    
    @IBOutlet weak var coachPositionLabel: UILabel!
    
    @IBOutlet weak var coachImageIcon: UIImageView!
    
    var coach: CoachingStaff? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        guard coach != nil else { return }
        self.coachNameLabel.text = (coach?.firstName)! + " " + (coach?.lastName)!
        self.coachPositionLabel.text = coach?.position
        if let imageUri = coach?.imageUri, let url = URL(string: (LivingstonFCAPIManager.sharedInstance.baseURL + imageUri)){
            loadImage(from: url) { [weak self] image in
                DispatchQueue.main.async {
                    self?.coachImageIcon.image = image
                }
            }
        }
    }

}
