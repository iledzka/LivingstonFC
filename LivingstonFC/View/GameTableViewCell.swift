//
//  GameTableViewCell.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 23/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  This class is used to represent cells in FixturesAndResultsViewController
//  and in the top section of NewsfeedViewController
class GameTableViewCell: UITableViewCell, UIScrollViewDelegate {
    
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
                self.upcoming = true
            } else if !(unwrappedGame.upcomingOrCurrent.upcoming)! {
                self.vsIcon.isHidden = true
            } else if (unwrappedGame.upcomingOrCurrent.upcoming)! {
                self.scoreStackView.isHidden = true
                self.upcoming = true
            }
            
        }
        
    }
    
}

//  Badges representing scores
var scores: [String: UIImage] = [
    "0" : UIImage(imageLiteralResourceName: "score0@3"),
    "1" : UIImage(imageLiteralResourceName: "score1@3"),
    "2" : UIImage(imageLiteralResourceName: "score2@3"),
    "3" : UIImage(imageLiteralResourceName: "score3@3"),
    "4" : UIImage(imageLiteralResourceName: "score4@3"),
    "5" : UIImage(imageLiteralResourceName: "score5@3"),
    "6" : UIImage(imageLiteralResourceName: "score6@3"),
    "7" : UIImage(imageLiteralResourceName: "score7@3"),
    "8" : UIImage(imageLiteralResourceName: "score8@3"),
    "9" : UIImage(imageLiteralResourceName: "score9@3"),
    "10" : UIImage(imageLiteralResourceName: "score10@3")
]

extension String {
    //  This function is used for the opponent's text label. It is used only when the team's name is too long to fit in one line
    func addReturnChar() -> String {
        if let range = self.range(of: "\\*?(\\s)", options: .regularExpression) {
            guard range.upperBound.encodedOffset > 3 else { return self } //return if the first substring is shorter than 4
            let substr = self[range]
            return self.replacingCharacters(in: range, with: "\n" + substr)
        }
        return self
    }
    // stringToFind must be at least 1 character.
    func countInstances(of stringToFind: String) -> Int {
        assert(!stringToFind.isEmpty)
        var count = 0
        var searchRange: Range<String.Index>?
        while let foundRange = range(of: stringToFind, options: .diacriticInsensitive, range: searchRange) {
            count += 1
            searchRange = Range(uncheckedBounds: (lower: foundRange.upperBound, upper: endIndex))
        }
        return count
    }
}
