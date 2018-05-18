//
//  MatchPastViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 29/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  Past match view
class MatchPastViewController: UIViewController {

    @IBOutlet weak var iconLivingston: UIImageView!
    @IBOutlet weak var iconOpponent: UIImageView!
    
    @IBOutlet weak var labelLivingston: UILabel!
    @IBOutlet weak var labelOpponent: UILabel!
    
    @IBOutlet weak var dateTime: UILabel!
    
    @IBOutlet weak var iconScoreLivingston: UIImageView!
    @IBOutlet weak var iconScoreOpponent: UIImageView!
    
    @IBOutlet weak var venue: UILabel!
    @IBOutlet weak var referee: UILabel!
    @IBOutlet weak var competition: UILabel!
    
    @IBOutlet weak var commentary: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = ""
        updateUI()
    }
    
    var game: Game?
    var opponentTeam: Team?
    var livingstonTeam: Team?

    private func updateUI() {
        if let imageURLopponent = opponentTeam?.badgeUrl{
            loadImage(from: imageURLopponent) {
                self.iconOpponent.image = $0
            }
        } else {
            iconOpponent.image = UIImage(imageLiteralResourceName: "badge_placeholder")
        }
        
        if let imageURLlivi = livingstonTeam?.badgeUrl{
            loadImage(from: imageURLlivi) {
                self.iconLivingston.image = $0
            }
        } else {
            iconLivingston.image = UIImage(imageLiteralResourceName: "badge_placeholder")
        }
        
        self.labelLivingston.text = "Livingston"
        self.labelOpponent.text = game?.opponent.addReturnChar()
        
        if let dateTime = game?.dateAndTime {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            self.dateTime.text = formatter.string(from: dateTime)
        } else {
            self.dateTime.text = nil
        }
        
        if let scoreLivingston = game?.scoreLivingston, let scoreOpponent = game?.scoreOpponent {
            self.iconScoreLivingston.image = scores[scoreLivingston]
            self.iconScoreOpponent.image = scores[scoreOpponent]
        }
        
        self.venue.text = game?.venue
        self.referee.text = game?.referee
        self.commentary.text = game?.commentary
        self.competition.text = game?.competition
    }
}
