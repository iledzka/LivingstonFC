//
//  PlayerStatsItemTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 05/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  A single player's stats cell
class PlayerStatsItemTableViewCell: UITableViewCell {

    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var playerName: UILabel!
    @IBOutlet weak var statsValue: UILabel!
    
    
    var player: Player? {
        didSet {
            updateUI()
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        position.text = nil
        playerName.text = nil
        statsValue.text = nil
        dataType = nil
    }
    
    var dataType: String?
    
    private func updateUI() {
        if let type = dataType {
            switch type {
            case "Top Scorers":
                statsValue.text = player?.goals
            case "Assists":
                statsValue.text = player?.assists
            case "Matches":
                statsValue.text = player?.matches
            case "Yellow Cards":
                statsValue.text = player?.yellowCards
            case "Red Cards":
                statsValue.text = player?.redCards
            default:
                return
            }
        }
        
        if let firstName = player?.firstName, let lastName = player?.lastName {
            playerName.text = firstName + " " + lastName
        }
    }

}
