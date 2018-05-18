//
//  SquadTableViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 27/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  This controller is responsible for displaying a liost of players.
//  The tabloe view has grouped type, and it dynamically segregates the players in sections based on
//  the player type. This could be achieved using TeamMember protocol.
class SquadTableViewController: UITableViewController {

    var teamMembers = [TeamMember]()
    private var tempPlayers = [Player]()
    private var players = [Player]() {
        didSet {
            var goalkeepers = [Player]()
            var defenders = [Player]()
            var midfielders = [Player]()
            var forward = [Player]()
            var striker = [Player]()
            var winger = [Player]()
            for player in players {
                switch player.position {
                case "Goalkeeper":
                    goalkeepers.append(player)
                case "Defender":
                    defenders.append(player)
                case "Midfielder":
                    midfielders.append(player)
                case "Forward":
                    forward.append(player)
                case "Striker":
                    striker.append(player)
                case "Winger":
                    winger.append(player)
                default:
                    break;
                }
            }
            
            teamMembers.append(Goalkeeper(goalkeepers))
            teamMembers.append(Defender(defenders))
            teamMembers.append(Midfielder(midfielders))
            teamMembers.append(Forward(forward))
            teamMembers.append(Striker(striker))
            teamMembers.append(Winger(winger))
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "SQUAD"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        LivingstonFCAPIManager.sharedInstance.getPlayers(onSuccess: { [weak self] players in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                for player in players{
                    self?.tempPlayers.append(player)
                }
                self?.players.append(contentsOf: players)
                self?.tableView.reloadData()
                
            }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.show(alert, sender: nil)
        })
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return teamMembers.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return teamMembers[section].rowCount
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "Player", for: indexPath) as? SquadTableViewCell {
            switch teamMembers[indexPath.section].type {
            case .goalkeeper:
                cell.player = (teamMembers[indexPath.section] as? Goalkeeper)?.players[indexPath.row]
            case .defender:
                cell.player = (teamMembers[indexPath.section] as? Defender)?.players[indexPath.row]
            case .forward:
                cell.player = (teamMembers[indexPath.section] as? Forward)?.players[indexPath.row]
            case .midfielder:
                cell.player = (teamMembers[indexPath.section] as? Midfielder)?.players[indexPath.row]
            case .striker:
                cell.player = (teamMembers[indexPath.section] as? Striker)?.players[indexPath.row]
            case .winger:
                cell.player = (teamMembers[indexPath.section] as? Winger)?.players[indexPath.row]
            }
            return cell
        }
        return UITableViewCell()
    }
    

    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let member = teamMembers[section]
        if member.rowCount > 0 {
            return member.sectionTitle
        }
        return nil
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerProfile", let destination = segue.destination as? PlayerProfileViewController, let indexPath = tableView.indexPathForSelectedRow {
            let player = teamMembers[indexPath.section]
            switch player.type {
            case .goalkeeper:
                destination.player = (player as? Goalkeeper)?.players[indexPath.row]
            case .defender:
                destination.player = (player as? Defender)?.players[indexPath.row]
            case .forward:
                destination.player = (player as? Forward)?.players[indexPath.row]
            case .midfielder:
                destination.player = (player as? Midfielder)?.players[indexPath.row]
            case .winger:
                destination.player = (player as? Winger)?.players[indexPath.row]
            case .striker:
                destination.player = (player as? Striker)?.players[indexPath.row]
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if !UserDefaultsManager.isFullMember() {
            let alert = CustomAlert.contentRestrictionAlert
            self.present(alert, animated: true, completion: nil)
        } else {
            performSegue(withIdentifier: "PlayerProfile", sender: self)
        }
    }
}
