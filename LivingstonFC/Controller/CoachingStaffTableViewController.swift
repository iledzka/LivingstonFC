//
//  CoachingStaffTableViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 27/04/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit


//  This controller manages view that displays the members of coaching staff
class CoachingStaffTableViewController: UITableViewController {

    var coaches = [CoachingStaff]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = "COACHING STAFF"
        tableView.estimatedRowHeight = 145
        tableView.rowHeight = 145
        
        
        LivingstonFCAPIManager.sharedInstance.getCoachingStaff(onSuccess: { [weak self] coachingStaff in
            DispatchQueue.main.async {
                if coachingStaff.count != self?.coaches.count{
                    self?.coaches.append(contentsOf: coachingStaff)
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
        return coaches.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "coachingStaff", for: indexPath) as? CoachingStaffTableViewCell {
            let coach = coaches[indexPath.row]
            cell.coach = coach
            return cell
        }
        return UITableViewCell()
    }
    

}
