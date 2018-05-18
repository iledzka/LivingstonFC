//
//  MatchUpcomingViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 29/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  Upcoming match view. 
class MatchUpcomingViewController: UIViewController {

    
    @IBOutlet weak var iconLivingston: UIImageView!
    @IBOutlet weak var iconOpponent: UIImageView!
    
    @IBOutlet weak var labelLivingston: UILabel!
    @IBOutlet weak var labelOpponent: UILabel!
    
    @IBOutlet weak var dateTimeLabel: UILabel!
    
    @IBOutlet weak var venueLabel: UILabel!
    @IBOutlet weak var refereeLabel: UILabel!
    @IBOutlet weak var competitionLabel: UILabel!
    
    @IBOutlet weak var travelLinkButton: UIButton!
    private var travelLink: URL?
    
    @IBAction func openTravelLink(_ sender: Any) {
        UIApplication.shared.open(self.travelLink!, options: [:], completionHandler: { (status) in
            
        })
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = " "
        self.travelLinkButton.layer.cornerRadius = 10
        
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
            self.dateTimeLabel.text = formatter.string(from: dateTime)
        } else {
            self.dateTimeLabel.text = nil
        }
        self.competitionLabel.text = game?.competition
        self.venueLabel.text = game?.venue
        self.refereeLabel.text = game?.referee
        self.travelLink = game?.travelLink
    }

}
