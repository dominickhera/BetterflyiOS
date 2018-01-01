//
//  newThirdPartySettingsTableViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 1/1/18.
//  Copyright © 2018 Dominick Hera. All rights reserved.
//

import UIKit

class newThirdPartySettingsTableViewController: UITableViewController {

    var data = ["Icons by Smashicons", "Social Icons by Freepik", "SCLAlertView", "IQKeyboardManagerSwift", "Firebase", "Fabric", "TwitterKit", "Facebook SDK", "Folding Cells", "Paper-Onboarding", "SimpleImageViewer", "SwipeableTabBarController", "SlackTextViewController"]
    var dataURLS = ["https://www.flaticon.com/packs/essential-set-2", "https://www.flaticon.com/packs/social-network-logo-collection", "https://github.com/vikmeup/SCLAlertView-Swift", "https://github.com/hackiftekhar/IQKeyboardManager", "https://firebase.google.com/terms/", "https://fabric.io/privacy", "https://twitter.com/en/tos", "https://www.facebook.com/legal/terms", "https://github.com/Ramotion/folding-cell", "https://github.com/Ramotion/paper-onboarding", "https://github.com/aFrogleap/SimpleImageViewer", "https://github.com/marcosgriselli/SwipeableTabBarController", "https://github.com/slackhq/SlackTextViewController"]
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        self.tabBarController?.tabBar.isHidden = true
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if self.userDefaults.bool(forKey: "isDarkModeEnabled") {
            tableView.backgroundColor = UIColor.black
            navigationController?.navigationBar.barTintColor = UIColor.black
        }
        else
        {
            navigationController?.navigationBar.barTintColor = UIColor.white
            tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
        }
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        if self.userDefaults.bool(forKey: "isDarkModeEnabled") {
            cell.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
            cell.textLabel?.textColor = UIColor.white
        }
        else
        {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
        }
        
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return data.count
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
                let controller = segue.destination as! newThirdPartyCreditWebViewController
//                controller.detailItem = object
                controller.urlString = dataURLS[indexPath.row]
                controller.titleString = data[indexPath.row]
                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
            }
        }
    }

}
