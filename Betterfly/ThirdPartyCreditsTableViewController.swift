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
    
     @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
//         dataSource?.bind(to: tableView)
        tableView.dataSource = self
        //        self.tabBarController?.tabBar.isHidden = false
        // Do any additional setup after loading the view.
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
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
//        let selectedItem = data[indexPath.row]
        self.performSegue(withIdentifier: "detail", sender: indexPath)
//        if(selectedItem == "Icons"){
//            let urlTest = "http://www.dominickhera.com/apps/betterfly/privacyPolicy.html"
//            performSegue(withIdentifier: "webCreditSegue", sender: urlTest)
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
        var data = ["Icons by Smashicons", "SCLAlertView", "IQKeyboardManagerSwift", "Firebase", "Fabric", "ParallaxHeader", "TwitterKit", "Facebook SDK", "Folding Cells", "Paper-Onboarding", "Transitionable Tab"]
        guard let indexPath: IndexPath = sender as? IndexPath else { return }
        guard let detail: ThirdPartyCreditWebViewController = segue.destination as? ThirdPartyCreditWebViewController else {
            return
        }
        
        let selectedItem = data[indexPath.row]
            if(selectedItem == "Icons by Smashicons"){
                detail.url = "https://www.flaticon.com/packs/essential-set-2"
            }
            else if(selectedItem == "SCLAlertView"){
                detail.url = "https://github.com/vikmeup/SCLAlertView-Swift"
            }
            else if(selectedItem == "IQKeyboardManagerSwift"){
                detail.url = "https://github.com/hackiftekhar/IQKeyboardManager"
            }
            else if(selectedItem == "Firebase"){
    
                detail.url = "https://firebase.google.com/terms/"
            }
            else if(selectedItem == "Fabric"){
                detail.url = "https://fabric.io/privacy"
            }
            else if(selectedItem == "ParallaxHeader"){
                detail.url = "https://github.com/romansorochak/ParallaxHeader"
            }
            else if(selectedItem == "TwitterKit") {
                detail.url = "https://twitter.com/en/tos"
    
            }
            else if(selectedItem == "Facebook SDK") {
                detail.url = "https://www.facebook.com/legal/terms"
    
            }
            else if(selectedItem == "Folding Cells") {
                detail.url = "https://github.com/Ramotion/folding-cell"
            }
            else if(selectedItem == "Paper-Onboarding") {
                detail.url = "https://github.com/Ramotion/paper-onboarding"
            }
            else if(selectedItem == "Transitionable Tab") {
                detail.url = "https://github.com/Interactive-Studio/TransitionableTab"
                print("url sending is \(detail.url)")
            }
            print("url sending is \(detail.url)")
            
        
}
//        else
//        {
//            return
//        }
        
        
        
//        if let dataSource = dataSource {
//            detail.creditURL = dataSource.snapshot(at: indexPath.row).text
//        }

    
//            if let dataSource = dataSource {
//                detail.postKey = dataSource.snapshot(at: indexPath.row).key
//            }
//        }

    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let destination = segue.destination as? Game{
//            if let easyURLStart = sender as? URL{
//                destination.startingURL = easyURLStart
//            }
//        }
//    }
//
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
//}

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
     MARK: - Navigation

     In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
         Get the new view controller using segue.destinationViewController.
         Pass the selected object to the new view controller.
    }
    */


