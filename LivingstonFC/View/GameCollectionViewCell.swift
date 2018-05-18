//
//  GameCollectionViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 11/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  This class respresent an object used in CollectionViewController responsible for displaying
//  games in NewsfeedViewController.
//  CollectionView must be used to implement a horizontal scrolling between games
class GameCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var imageLivingston: UIImageView!
    @IBOutlet weak var imageOpponent: UIImageView!
    @IBOutlet weak var labelLivingston: UILabel!
    @IBOutlet weak var labelOpponent: UILabel!
    @IBOutlet weak var scoreLivingston: UIImageView!
    @IBOutlet weak var scoreOpponent: UIImageView!
    @IBOutlet weak var date: UILabel!
    
    @IBOutlet weak var vsIcon: UIImageView!
    
    @IBOutlet weak var scoreStackView: UIStackView!
    var game: Game? {
        didSet {
            updateUI()
        }
    }
    
    var opponentTeam: Team?
    var livingstonTeam: Team?
    
    var upcoming = false
    
    private func updateUI() {
        if let unwrappedGame = game {
            
            self.labelLivingston.text = "Livingston"
            self.labelOpponent.text = unwrappedGame.opponent.addReturnChar()
            
            let currentOpponent = self.labelOpponent.text
            
            if let imageURLopponent = opponentTeam?.badgeUrl{
                loadImage(from: imageURLopponent) {
                    guard currentOpponent == self.labelOpponent.text else { return }
                    self.imageOpponent.image = $0
                }
            } else {
                imageOpponent.image = UIImage(imageLiteralResourceName: "badge_placeholder")
            }
            
            if let imageURLlivi = livingstonTeam?.badgeUrl{
                loadImage(from: imageURLlivi) {
                    guard currentOpponent == self.labelOpponent.text else { return }
                    self.imageLivingston.image = $0
                }
            } else {
                imageLivingston.image = UIImage(imageLiteralResourceName: "badge_placeholder")
            }
            
            if let scoreOpp = unwrappedGame.scoreOpponent, let scoreLivi = unwrappedGame.scoreLivingston {
                self.scoreOpponent.image = scores[scoreOpp]
                self.scoreLivingston.image = scores[scoreLivi]
            }
            
            if let dateTime = unwrappedGame.dateAndTime {
                let formatter = DateFormatter()
                formatter.dateStyle = .medium
                formatter.timeStyle = .short
                self.date.text = formatter.string(from: dateTime)
            } else {
                self.date.text = nil
            }
            
            //Show either the score icons or vs_icon if the match is upcoming
            if (unwrappedGame.upcomingOrCurrent.current == true){
                self.scoreStackView.isHidden = true
                self.vsIcon.isHidden = false
                self.upcoming = true
            } else if !(unwrappedGame.upcomingOrCurrent.upcoming)! {
                self.vsIcon.isHidden = true
                self.scoreStackView.isHidden = false
            } else if (unwrappedGame.upcomingOrCurrent.upcoming)! {
                self.scoreStackView.isHidden = true
                self.vsIcon.isHidden = false
                self.upcoming = true
            }
 
        }
        
    }
    
}



