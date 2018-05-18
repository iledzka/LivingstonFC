//
//  SquadTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 01/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  This class configures a single player table view cell 
class SquadTableViewCell: UITableViewCell {


    @IBOutlet weak var playerIcon: UIImageView!
    @IBOutlet weak var playerName: UILabel!
  
    
    var player: Player? {
        didSet {
            updateUI()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.playerIcon.frame.size = CGSize(width: 25.0, height: 25.0)
    }

    private func updateUI() {
        self.playerName.text = "\(player?.firstName ?? "") \(player?.lastName ?? "")"
        let currentPlayerName = self.playerName.text
        let url = LivingstonFCAPIManager.sharedInstance.baseURL + (player?.imageIcon)!
        let imgUrl = URL(string: url)
        loadImage(from: imgUrl!) {
            guard currentPlayerName == self.playerName.text else { return }
            self.playerIcon.image = $0
        }
    }
}
