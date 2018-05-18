//
//  LeagueTableItemTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 03/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  A single cell visible in StatsViewController - one represents stats for a team in a competition
class LeagueTableItemTableViewCell: UITableViewCell {

    var statsItem: LeagueTableStatsItem? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var positionLabel: UILabel!
    @IBOutlet weak var teamNameLabel: UILabel!
    @IBOutlet weak var playedLabel: UILabel!
    @IBOutlet weak var wonLabel: UILabel!
    @IBOutlet weak var drawnLabel: UILabel!
    @IBOutlet weak var lostLabel: UILabel!
    @IBOutlet weak var forAgainstLabel: UILabel!
    @IBOutlet weak var pointsLabel: UILabel!
    
    private func updateUI(){
        self.positionLabel.text = statsItem?.position
        self.teamNameLabel.text = statsItem?.teamName
        self.playedLabel.text = statsItem?.played
        self.wonLabel.text = statsItem?.won
        self.drawnLabel.text = statsItem?.drawn
        self.lostLabel.text = statsItem?.lost
        if let forTimes = statsItem?.forTimes, let against = statsItem?.against {
            self.forAgainstLabel.text = forTimes + "/" + against
        }
        self.pointsLabel.text = statsItem?.points
    }
}
