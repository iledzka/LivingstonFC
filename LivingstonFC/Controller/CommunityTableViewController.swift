//
//  CommunityTableViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 27/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  Community is a section where fans can find an event hosted by Livingston FC.
//  This controller manages the view that displays a list of available events.
class CommunityTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "COMMUNITY"
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        
        LivingstonFCAPIManager.sharedInstance.getCommunityEvents(onSuccess: { [weak self] events in
            DispatchQueue.main.async {
                self?.tableView.reloadData()
                self?.events.append(contentsOf: events)
                self?.tableView.reloadData()
                
            }
            }, onFailure: { error in
                let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Dismiss", style: .default, handler: nil))
                self.show(alert, sender: nil)
        })
    }

    var events = [Community]()
   

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return events.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "communityCell", for: indexPath) as? CommunityTableViewCell {
            let event = events[indexPath.row]
            cell.event = event
            return cell
        }

        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "showEvent", sender: self)
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showEvent", let destination = segue.destination as? CommunityItemViewController, let indexPath = tableView.indexPathForSelectedRow {
            let event = events[indexPath.row]
            destination.event = event
        }
    }


}
