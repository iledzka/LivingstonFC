//
//  FixturesAndResultsTableViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 27/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  Table view that shows games
//  Most recent game at the top
class FixturesAndResultsTableViewController: UITableViewController {

    private var games = [Game]() {
        didSet {
            games = games.sorted {
                $0.dateAndTime! > $1.dateAndTime!
            }
        }
    }
    
    private var team = [String:Team]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "FIXTURES & RESULTS"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
      
        LivingstonFCAPIManager.sharedInstance.getTeams(onSuccess: { [weak self] teams in
            DispatchQueue.main.async {
                if teams.count != self?.team.count {
                    for object in teams {
                        self?.team[object.name] = object
                        self?.tableView.reloadData()
                    }
                }
            }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.show(alert, sender: nil)
        })
        
        LivingstonFCAPIManager.sharedInstance.getGames(onSuccess: { [weak self] games in
            DispatchQueue.main.async {
                if games.count != self?.games.count {
                    self?.games.removeAll()
                    self?.games = games
                    self?.tableView.reloadData()
                }
                
            }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.show(alert, sender: nil)
        })
    }
    


    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return games.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        if let gameCell = tableView.dequeueReusableCell(withIdentifier: "Games", for: indexPath) as? GameTableViewCell {
        
            let game = games[indexPath.row]
            
            if let opponent = team[game.opponent], let livingston = team["Livingston FC"] {
                gameCell.opponentTeam = opponent
                gameCell.livingstonTeam = livingston
            }
            gameCell.game = game
            
            return gameCell
        }

        return UITableViewCell()
    }
 
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedGame = games[indexPath.row]
        if selectedGame.upcomingOrCurrent.upcoming! {
            performSegue(withIdentifier: "UpcomingMatch", sender: self)
        } else if !selectedGame.upcomingOrCurrent.upcoming! {
            performSegue(withIdentifier: "PastMatch", sender: self)
        }
        
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "UpcomingMatch", let destination = segue.destination as? MatchUpcomingViewController {
            if let _ = sender as? FixturesAndResultsTableViewController, let indexPath = tableView.indexPathForSelectedRow {
                let selectedGame = games[indexPath.row]
                destination.game = selectedGame
                if let opponent = team[selectedGame.opponent], let livingston = team["Livingston FC"] {
                    destination.opponentTeam = opponent
                    destination.livingstonTeam = livingston
                }
            }
        } else if segue.identifier == "PastMatch", let destination = segue.destination as? MatchPastViewController {
            if let _ = sender as? FixturesAndResultsTableViewController, let indexPath = tableView.indexPathForSelectedRow {
                let selectedGame = games[indexPath.row]
                destination.game = selectedGame
                if let opponent = team[selectedGame.opponent], let livingston = team["Livingston FC"] {
                    destination.opponentTeam = opponent
                    destination.livingstonTeam = livingston
                }
            }
        }
    }
}
