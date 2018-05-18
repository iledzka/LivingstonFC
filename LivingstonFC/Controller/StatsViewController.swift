//
//  StatsViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 03/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  This controller displays the League Table and Player stats.
//  It consists of a view with two buttons and a picker that appears only when Players' stats are displayed
//  As the controller conforms to UITableViewDelegate and UITableViewDelegate,
//  it can manage its subview - a tabe view that displays the stats.
class StatsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    @IBOutlet weak var picker: UIButton!
    @IBOutlet weak var pickerView: UIPickerView!
    var players = [Player]()
    var playerPickerData = ["Goals", "Assists", "Yellow Cards", "Red Cards", "Matches"]
    @IBOutlet weak var playerStatsTypeLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var headerView: UIView!
    
    @IBOutlet weak var buttonsStackView: UIStackView!
    
    @IBOutlet weak var leagueTableButton: UIButton!
    @IBOutlet weak var playersButton: UIButton!
    @IBOutlet weak var headerViewPlayer: UIView!
    
    
    var leagueTableItems = [LeagueTableStatsItem]() {
        didSet {
            //make sure the table is sorted by position in the table
            leagueTableItems = leagueTableItems.sorted {
                ($0.position).localizedStandardCompare($1.position) == .orderedAscending
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "STATS"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        pickerView.isHidden = true
        pickerView.delegate = self
        pickerView.dataSource = self
        
        //Load Players only when user is a full member.
        if UserDefaultsManager.isFullMember() {
            LivingstonFCAPIManager.sharedInstance.getPlayers(onSuccess: { [weak self] playersArray in
                DispatchQueue.main.async {
                    for player in playersArray{
                        self?.players.append(player)
                    }
                    self?.tableView.reloadData()
                    
                }
                }, onFailure: { error in
                    let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                    self.show(alert, sender: nil)
            })
        }
        LivingstonFCAPIManager.sharedInstance.getCompetitionStats(onSuccess: { [weak self] stats in
            DispatchQueue.main.async {
                for statsItem in stats {
                    self?.leagueTableItems.append(statsItem)
                }
                self?.tableView.rowHeight = (self?.tableView.frame.height)! / CGFloat(stats.count)
                self?.tableView.reloadData()
                
            }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.show(alert, sender: nil)
        })
        
        //hide picker when first loaded
        hidePicker()
    }
   
    private func hidePicker() {
        self.headerViewTopConstraint.constant -= self.picker.frame.height
        picker.isHidden = true
        headerView.isHidden = false
        headerViewPlayer.isHidden = true
        self.view.layoutIfNeeded()
    }
    
    @IBOutlet weak var headerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var headerViewBottomConstraint: NSLayoutConstraint!
    
    @IBAction func showLeagueTable(_ sender: Any) {
        if !headerViewPlayer.isHidden, headerView.isHidden {
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.headerViewPlayer.isHidden = true
                self.headerView.isHidden = false
            }, completion: nil)
        }
        playersButton.backgroundColor = UIColor.lightGray
        leagueTableButton.backgroundColor = UIColor.darkGray
        //hide picker
        if !picker.isHidden {
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.shouldActivateTableTopConstraint(false)
                self.headerViewTopConstraint.constant -= self.picker.frame.height
                self.headerViewBottomConstraint.constant -= self.picker.frame.height
                self.view.layoutIfNeeded()
                
            }, completion: { completed in
                if completed {
                    self.picker.isHidden = true
                    self.tableView.reloadData()
                }
            })
        }
    }
    
    @IBAction func showPlayersStats(_ sender: Any) {
        if !UserDefaultsManager.isFullMember() {
            let alert = CustomAlert.contentRestrictionAlert
            self.present(alert, animated: true, completion: nil)
            return
        }
        if headerViewPlayer.isHidden, !headerView.isHidden {
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
            self.headerViewPlayer.isHidden = false
            self.headerView.isHidden = true
            }, completion: nil)
        }
        playersButton.backgroundColor = UIColor.darkGray
        leagueTableButton.backgroundColor = UIColor.lightGray
        //show picker
        if picker.isHidden {
            UIView.animate(withDuration: 0.1, delay: 0, options: UIViewAnimationOptions.curveEaseIn, animations: {
                self.headerViewTopConstraint.constant += self.picker.frame.height
                self.headerViewBottomConstraint.constant += self.picker.frame.height
                self.shouldActivateTableTopConstraint(true)
                self.view.layoutIfNeeded()
                
            }, completion: nil)
            picker.isHidden = false
            tableView.reloadData()
            sortPlayers(by: picker.currentTitle ?? " ")
        }
    }
    
    @IBAction func pickerViewPressed(_ sender: Any) {
        if pickerView.isHidden {
            pickerView.isHidden = false
        }
    }
    private var tableTopConstraint: NSLayoutConstraint {
        return NSLayoutConstraint(item: tableView, attribute: NSLayoutAttribute.top, relatedBy: NSLayoutRelation.equal
            , toItem: headerView, attribute: NSLayoutAttribute.bottom, multiplier: 1, constant: 0)
    }
    
    private func shouldActivateTableTopConstraint(_ activate: Bool) {
        if activate {
            NSLayoutConstraint.activate([tableTopConstraint])
        } else {
            NSLayoutConstraint.deactivate([tableTopConstraint])
        }
    }
    
    private func sortPlayers(by pickedValue: String){
        switch pickedValue {
        case "Assists":
            players = players.sorted {
                return $0.assists > $1.assists
            }
        case "Goals", "Top Scorers":
            players = players.sorted {
                ($0.goals).localizedStandardCompare($1.goals) == .orderedDescending
            }
        case "Yellow Cards":
            players = players.sorted {
                ($0.yellowCards).localizedStandardCompare($1.yellowCards) == .orderedDescending
            }
        case "Red Cards":
            players = players.sorted {
                ($0.redCards).localizedStandardCompare($1.redCards) == .orderedDescending
            }
        case "Matches":
            players = players.sorted {
                ($0.matches).localizedStandardCompare($1.matches) == .orderedDescending
            }
        default:
            return
        }
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if picker.isHidden {
            return leagueTableItems.count
        } else {
            return players.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if picker.isHidden {
            if let leagueTableItemCell = tableView.dequeueReusableCell(withIdentifier: "LeagueTableItem", for: indexPath) as? LeagueTableItemTableViewCell {
                let statsItem = leagueTableItems[indexPath.row]
                leagueTableItemCell.statsItem = statsItem
                return leagueTableItemCell
            }
        } else {
            if let playerStatsItemCell = tableView.dequeueReusableCell(withIdentifier: "PlayerStatsItem", for: indexPath) as? PlayerStatsItemTableViewCell {
                let player = players[indexPath.row]
                playerStatsItemCell.dataType = picker.titleLabel?.text
                playerStatsItemCell.player = player
                return playerStatsItemCell
            }
        }
        
        
        return UITableViewCell()
    }
    

    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "PlayerProfileFromStats", let destination = segue.destination as? PlayerProfileViewController {
            if let indexPath = tableView.indexPathForSelectedRow {
                let player = players[indexPath.row]
                destination.player = player
            }
        }
    }
    

}

extension StatsViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return playerPickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return playerPickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        playerStatsTypeLabel.text = playerPickerData[row]
        let newTitle = (playerPickerData[row] == "Goals") ? "Top Scorers" : playerPickerData[row]
        picker.setTitle(newTitle, for: .normal)
        pickerView.isHidden = true
        sortPlayers(by: playerPickerData[row])
        tableView.reloadData()
    }
    
    
}
