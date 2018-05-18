//
//  PickerButton.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 05/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  This class is used to style UIPicker button
class PickerButton: UIButton {

    override func layoutSubviews() {
        super.layoutSubviews()
        if imageView != nil {
            imageEdgeInsets = UIEdgeInsets(top: 5, left: (bounds.width - 45), bottom: 5, right: 5)
            titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: (imageView?.frame.width)!)
        }
        titleLabel?.adjustsFontSizeToFitWidth = true
    }

}
