//
//  CommunityTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 06/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


class CommunityTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    
    var event: Community? {
        didSet {
            updateUI()
        }
    }
    
    private func updateUI() {
        self.titleLabel.text = event?.name
    }

}
