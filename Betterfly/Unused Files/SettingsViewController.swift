//
//  SettingsViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/12/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import MessageUI

class SettingsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var data = ["About Us","Contact Us", "Website","App Preferences","Rate the App", "Share the App","Terms and Conditions", "Privacy Policy", "Third Party Credits", "Sign Out"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        tableView.delegate = self
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
        let selectedItem = data[indexPath.row]
        
        if(selectedItem == "Share the App"){
            let activityViewController = UIActivityViewController(activityItems: ["Hey, you should check out this cool new app for keeping track of positive thoughts made by Dominick Hera!"], applicationActivities: nil)
            present(activityViewController, animated: true, completion: {})
        }
        else if(selectedItem == "Rate the App"){
            print("this will take you to the app page later on")
        }
        else if(selectedItem == "Social Media"){
            print("this will show my twitter and instagram and personal website i guess?")
        }
        else if(selectedItem == "Contact Us"){
            
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
                
                //Then just cast the object as a String, but be careful, you may want to double check for nil
                let version = nsObject as! String
                mail.mailComposeDelegate = self
                mail.setToRecipients(["support@dominickhera.com"])
                mail.setSubject("Betterfly Question")
                mail.setMessageBody("<p>Device: \(UIDevice.current.modelName)</br>App: Betterfly</br>App Version: \(version)</br></br></p>", isHTML: true)
                
                present(mail, animated: true)
            } else {
                // show failure alert
            }
            print("will provide email so i can be contacted")
        }
        else if(selectedItem == "About the App"){
            print("this will talk about why i decided to make this app in the first place")
        }
        else if(selectedItem == "About Us"){
//            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "aboutMePage")
//            {
//                //            print("peehole")
////                self.present(VC, animated: true, completion: nil)
//            }
            
            self.performSegue(withIdentifier: "aboutMeSegue", sender: indexPath)
        }
        else if(selectedItem == "Third Party Credits") {
            print("Icons made by [AUTHOR LINK] from www.flaticon.com")
            self.performSegue(withIdentifier: "creditsSegue", sender: indexPath)
            
        }
        else if(selectedItem == "Terms and Conditions") {
            self.performSegue(withIdentifier: "termsSegue", sender: indexPath)
        }
        else if(selectedItem == "Privacy Policy") {
            self.performSegue(withIdentifier: "privacySegue", sender: indexPath)
        }
        else if(selectedItem == "Sign Out"){
            let firebaseAuth = Auth.auth()
            
            
            //        do {
            //            try GIDSignIn.sharedInstance().signOut()
            //        } catch let signOutError as NSError {
            //            print ("\n\nError signing out: %@", signOutError)
            //        }
            
            do {
                GIDSignIn.sharedInstance().signOut()
                try firebaseAuth.signOut()
            } catch let signOutError as NSError {
                print ("\n\nError signing out: %@", signOutError)
            }
            
            if let VC = self.storyboard?.instantiateViewController(withIdentifier: "signUpPage")
            {
                //            print("peehole")
                self.present(VC, animated: true, completion: nil)
            }
        }
        
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }

}

public extension UIDevice {
    
    var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        return identifier
    }
}
