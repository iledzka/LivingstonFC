//
//  PlayerProfileViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 02/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

class PlayerProfileViewController: UIViewController {

    @IBOutlet weak var backgroundImage: UIImageView!
    @IBOutlet weak var icon: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var position: UILabel!
    @IBOutlet weak var dateOfBirth: UILabel!
    @IBOutlet weak var height: UILabel!
    @IBOutlet weak var signed: UILabel!
    @IBOutlet weak var nationality: UILabel!
    @IBOutlet weak var redCards: UILabel!
    @IBOutlet weak var matches: UILabel!
    @IBOutlet weak var yellowCards: UILabel!
    @IBOutlet weak var goals: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }

    var player: Player?

    private func updateUI() {
        if let unwrappedPlayer = player {
            self.name.text = unwrappedPlayer.firstName + " " + unwrappedPlayer.lastName
            let currentPlayerName = self.name.text
            let url = LivingstonFCAPIManager.sharedInstance.baseURL + unwrappedPlayer.imageIcon
            if let imgUrl = URL(string: url){
                loadImage(from: imgUrl) {
                    guard currentPlayerName == self.name.text else { return }
                    self.icon.image = $0
                }
            }
            if let bImg = URL(string:LivingstonFCAPIManager.sharedInstance.baseURL + unwrappedPlayer.backgroundImg) {
                loadImage(from: bImg) {
                    guard currentPlayerName == self.name.text else { return }
                    self.backgroundImage.image = $0
                }
            }
            self.position.text = unwrappedPlayer.position
            self.dateOfBirth.text = unwrappedPlayer.dateOfBirth
            self.height.text = unwrappedPlayer.height
            self.signed.text = unwrappedPlayer.signed
            self.nationality.text = unwrappedPlayer.nationality
            self.redCards.text = unwrappedPlayer.redCards
            self.matches.text = unwrappedPlayer.matches
            self.yellowCards.text = unwrappedPlayer.yellowCards
            self.goals.text = unwrappedPlayer.goals
            
            self.icon.bottomAnchor.constraint(equalTo: self.backgroundImage.bottomAnchor).isActive = true
        }
    }
}
