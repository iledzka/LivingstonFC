//
//  StadiumTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 06/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class StadiumTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    @IBOutlet weak var titleLabel: UILabel!
    
    var rowTitle: String? {
        didSet {
            self.titleLabel.text = rowTitle
        }
    }

}
