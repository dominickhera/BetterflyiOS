//
//  ThirdPartyCreditsTableViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/23/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import MessageUI

class ThirdPartyCreditsTableViewController:  UIViewController, UITableViewDelegate, UITableViewDataSource {

    var data = ["Icons by Smashicons", "SCLAlertView", "IQKeyboardManagerSwift", "Firebase", "Fabric", "ParallaxHeader", "TwitterKit", "Facebook SDK", "Folding Cells", "Paper-Onboarding", "Transitionable Tab"]
    var url = "https://www.flaticon.com/packs/essential-set-2"
     @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
//         dataSource?.bind(to: tableView)
        tableView.dataSource = self
                self.tabBarController?.tabBar.isHidden = true
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = true
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        //        cell.backgroundColor = UIColor.clear
        //        cell.textLabel?.textColor = UIColor.white
        //        cell.textLabel?.font = UIFont(name: "SF UI Text", size:22)
        //        cell.textLabel?.font = UIFont(name:"Avenir", size:30)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedItem = data[indexPath.row]
       
//        if(selectedItem == "Icons by Smashicons"){
////            print("dickhole")
////             performSegue(withIdentifier: "detail", sender: "https://www.flaticon.com/packs/essential-set-2")
//            let destinationVC = ThirdPartyCreditWebViewController()
//            let urlThing = "https://www.flaticon.com/packs/essential-set-2"
//            destinationVC.performSegue(withIdentifier: "detail", sender: urlThing)
////            let urlTest = "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html"
////            performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
//        }
//        else if(selectedItem == "SCLAlertView"){
////            let urlTest = URL(string: "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html")
////                performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
//        }
//        else if(selectedItem == "IQKeyboardManagerSwift"){
////            let urlTest = URL(string: "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html")
////            performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
//        }
//        else if(selectedItem == "Firebase"){
//
////            let urlTest = URL(string: "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html")
////            performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
//        }
//        else if(selectedItem == "Fabric"){
////            let urlTest = URL(string: "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html")
////            performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
//        }
//        else if(selectedItem == "ParallaxHeader"){
////            let urlTest = URL(string: "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html")
////            performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
//        }
//        else if(selectedItem == "TwitterKit") {
////            let urlTest = URL(string: "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html")
////            performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
//
//        }
//        else if(selectedItem == "Facebook SDK") {
////            let urlTest = URL(string: "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html")
////            performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
//
//        }
    
        }
        
    }
    
    
//func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//    if let destination = segue.destination as? Game{
//        if let easyURLStart = sender as? URL{
//            destination.startingURL = easyURLStart
//        }
//    }

    
    func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detail" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let object = objects[indexPath.row] as! NSDate
                let controller = (segue.destination as! UINavigationController) as! ThirdPartyCreditWebViewController
//                controller.detailItem = object
                controller.urlTest = "butholeTest"
//                controller.navigationItem.leftBarButtonItem = splitViewController?.displayModeButtonItem
                controller.navigationItem.leftItemsSupplementBackButton = true
//            }
        }
    }


