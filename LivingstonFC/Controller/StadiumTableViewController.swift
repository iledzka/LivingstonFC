//
//  StadiumTableViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 27/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  This controller manages view that displays a list of sections containing infomartion about the Livingston FC stadium
class StadiumTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "STADIUM"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }

    var rowTitles = ["Conferencing", "Events", "Matchday Hospitality", "Matchday Fans Menus", "Almondvale Suite"]

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rowTitles.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "stadiumCell", for: indexPath) as? StadiumTableViewCell {
            let rowTitle = rowTitles[indexPath.row]
            cell.rowTitle = rowTitle
            return cell
        }
        
        return UITableViewCell()
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch rowTitles[indexPath.row] {
        case "Conferencing":
            performSegue(withIdentifier: "showConferencing", sender: self)
        case "Events":
            performSegue(withIdentifier: "showEvents", sender: self)
        case "Matchday Hospitality":
            performSegue(withIdentifier: "showMatchdayHospitality", sender: self)
        case "Matchday Fans Menus":
            performSegue(withIdentifier: "showMatchdayFansMenus", sender: self)
        case "Almondvale Suite":
            let urlString = "https://foodcreations.co.uk/venues/almondvale-suite/"
            if let url = URL(string: urlString) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        default:
            return
        }
    }
    
    // MARK: - Navigation
    

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }

}
