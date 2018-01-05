//
//  testSettingsViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/28/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import QuickTableViewController
import Weakify
import Firebase
import GoogleSignIn
import MessageUI
import Crashlytics
import FBSDKCoreKit
import FBSDKLoginKit
import Kingfisher

internal final class testSettingsViewController: QuickTableViewController, MFMailComposeViewControllerDelegate {
    let userDefaults = UserDefaults.standard
    private final class CustomCell: UITableViewCell {}
    private final class CustomSwitchCell: SwitchCell {}
    private final class CustomTapActionCell: TapActionCell {}
    private final class CustomOptionCell: UITableViewCell {}
    
    // MARK: - Properties
    
    private let debugging = Section(title: nil, rows: [])
    
    // MARK: - UIViewController
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = ""
//        let userDefaults = UserDefaults.standard
        let use24HourTime = userDefaults.bool(forKey: "is24HourTimeEnabled")
        let useManualDarkMode = userDefaults.bool(forKey: "isDarkModeEnabled")
        
        tableContents = [
            Section(title: "Settings", rows: [
                NavigationRow(title: "About Us", subtitle: .none, action: weakify(self, type(of: self).showAboutMe)),
                NavigationRow(title: "Terms and Conditions", subtitle: .none, action: weakify(self, type(of: self).showTOC)),
                NavigationRow(title: "Privacy Policy", subtitle: .none, action: weakify(self, type(of: self).showPrivacyPolicy)),
                NavigationRow(title: "Third Party Credits", subtitle: .none, action: weakify(self, type(of: self).showThirdParty)),
                ]),
            
            Section(title: "App Toggles", rows: [
                SwitchRow<SwitchCell>(title: "24 Hour Time", switchValue: use24HourTime, action: weakify(self, type(of: self).toggle24HourTime)),
                SwitchRow<SwitchCell>(title: "Dark Mode", switchValue: useManualDarkMode, action: weakify(self, type(of: self).toggleManualDarkMode))
//                SwitchRow<SwitchCell>(title: "Auto Dark Mode", switchValue: false, action: weakify(self, type(of: self).enableAutoDarkMode))], footer: "Auto Dark Mode automatically changes the app theme to dark mode at sunset until sunrise the next day."),
//                SwitchRow<SwitchCell>(title: "Post Reminders", switchValue: false, action: weakify(self, type(of: self).createEmail)),
//                NavigationRow(title: "Reminder Settings", subtitle: .none, action: weakify(self, type(of: self).showDetail))
                ]),
            
            Section(title: "Links", rows: [
                TapActionRow<CustomTapActionCell>(title: "Contact Us", action: weakify(self, type(of: self).createEmail)),
                TapActionRow<CustomTapActionCell>(title: "Website", action: weakify(self, type(of: self).openWebsite)),
                TapActionRow<CustomTapActionCell>(title: "Share App", action: weakify(self, type(of: self).shareApp)),
                TapActionRow<CustomTapActionCell>(title: "Rate App", action: weakify(self, type(of: self).rateApp))
                
                ]),
            
            Section(title: "", rows: [
                TapActionRow<CustomTapActionCell>(title: "Sign Out", action: weakify(self, type(of: self).signOut))
                
                ]),
            
            debugging
        ]
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.tabBarController?.tabBar.isHidden = false
        self.navigationController!.navigationBar.setBackgroundImage(nil, for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = nil
        
        if self.userDefaults.bool(forKey: "isDarkModeEnabled") {
            tableView.backgroundColor = UIColor.black
            navigationController?.navigationBar.barTintColor = UIColor.black
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        }
        else
        {
            navigationController?.navigationBar.barTintColor = UIColor.white
            tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        self.tableView.reloadData()
//        self.navigationController!.navigationBar.isTranslucent = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        userDefaults.synchronize()
    }
    // MARK: - UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if self.userDefaults.bool(forKey: "isDarkModeEnabled") {
            cell.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
            cell.textLabel?.textColor = UIColor.white
        }
        else
        {
            cell.backgroundColor = UIColor.white
            cell.textLabel?.textColor = UIColor.black
        }
        
        // Alter the cells created by QuickTableViewController
        return cell
    }
    
    // MARK: - Private Methods
    
    private func didToggleSelection(_ sender: Row) {
//        guard let option = sender as? OptionSelectable else {
//            return
//        }
//        let state = "\(option.title) is " + (option.isSelected ? "selected" : "deselected")
//        print(state)
//        showDebuggingText(state)
        print("hiya")
    }
    
    private func didToggleSwitch(_ sender: Row) {
//        if let row = sender as? Switchable {
//            let state = "\(row.title) = \(row.switchValue)"
//            print(state)
//            showDebuggingText(state)
//        }
        print("booty")
    }
    
    private func showAlert(_ sender: Row) {
        let alert = UIAlertController(title: "Action Triggered", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel) { [unowned self] _ in
            self.dismiss(animated: true, completion: nil)
        })
        present(alert, animated: true, completion: nil)
    }
    
    private func showDetail(_ sender: Row) {
        let detail = "\(sender.title)\(sender.subtitle?.text ?? "")"
        let controller = UIViewController()
        controller.view.backgroundColor = UIColor.white
        controller.title = detail
        navigationController?.pushViewController(controller, animated: true)
        showDebuggingText(detail + " is selected")
    }
    
    private func showAboutMe(_ sender: Row) {
        self.performSegue(withIdentifier: "aboutMeSegue", sender: sender)
    }
    
    private func showTOC(_ sender: Row) {
        self.performSegue(withIdentifier: "tocSegue", sender: sender)
    }
    
    private func showThirdParty(_ sender: Row) {
        self.performSegue(withIdentifier: "thirdPartyCreditSegue", sender: sender)
    }
    
    private func showPrivacyPolicy(_ sender: Row) {
        self.performSegue(withIdentifier: "privacyPolicySegue", sender: sender)
    }
    
    
    private func showDebuggingText(_ text: String) {
        debugging.rows = [NavigationRow(title: text, subtitle: .none)]
        let indexSet: IndexSet? = tableContents.index(where: { $0 === debugging }).map { [$0] }
        tableView.reloadSections(indexSet ?? [], with: .none)
    }
    
    private func openWebsite() {
        let url = URL(string: "http://www.dominickhera.com")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
            // Fallback on earlier versions
        }
    }
    
    private func toggleManualDarkMode() {
//        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "isDarkModeEnabled") {
            userDefaults.set(false, forKey: "isDarkModeEnabled")
            navigationController?.navigationBar.barTintColor = UIColor.white
            tableView.backgroundColor = UIColor(red:0.94, green:0.94, blue:0.96, alpha:1.0)
            print("um")
        }
        else
        {
            print("what")
            userDefaults.set(true, forKey: "isDarkModeEnabled")
            tableView.backgroundColor = UIColor.black
            navigationController?.navigationBar.barTintColor = UIColor.black
        }
        self.tableView.reloadData()

//        userDefaults.synchronize()
    }
    
    private func toggle24HourTime() {
//        let userDefaults = UserDefaults.standard
        if userDefaults.bool(forKey: "is24HourTimeEnabled") {
            userDefaults.set(false, forKey: "is24HourTimeEnabled")
//            print("um11111")
        }
        else
        {
//            print("what1111")
            userDefaults.set(true, forKey: "is24HourTimeEnabled")
        }
        
//        userDefaults.synchronize()
    }
    
//    private func enableAutoDarkMode(){
//        var locationManager: CLLocationManager!
//        locationManager = CLLocationManager()
//        locationManager.delegate = self
//        locationManager.requestWhenInUseAuthorization()
//    }
    
//    private func actualEnableAutoDarkMode(){
//
//    }
//
//    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
//        if status == .authorizedAlways {
//            if CLLocationManager.isMonitoringAvailable(for: CLBeaconRegion.self) {
//                if CLLocationManager.isRangingAvailable() {
//                    // do stuff
//                }
//            }
//        }
//    }
    
    private func createEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            let nsObject: AnyObject? = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as AnyObject
            
            //Then just cast the object as a String, but be careful, you may want to double check for nil
            let version = nsObject as! String
            mail.mailComposeDelegate = self
            mail.setToRecipients(["support@dominickhera.com"])
            mail.setSubject("Betterfly Question")
            mail.setMessageBody("<p>Device: \(UIDevice.current.model)</br>App: Betterfly</br>App Version: \(version)</br></br></p>", isHTML: true)
            
            present(mail, animated: true)
        } else {
            // show failure alert
        }
    }
    
    internal func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    private func shareApp() {
        let activityViewController = UIActivityViewController(activityItems: ["Check out this cool app called Bettrfly! itunes.apple.com/app/id1282712660"], applicationActivities: nil)
        present(activityViewController, animated: true, completion: {})
    }
    
    private func rateApp() {
        let url = URL(string: "itms-apps://itunes.apple.com/app/id1282712660")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
            // Fallback on earlier versions
        }
    }
    
    private func signOut() {
        let firebaseAuth = Auth.auth()
        
        do {
            FBSDKAccessToken.setCurrent(nil)
            GIDSignIn.sharedInstance().signOut()
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("\n\nError signing out: %@", signOutError)
        }
        userDefaults.set(false, forKey: "isSignedIn")
        userDefaults.set("", forKey: "signInMode")
        userDefaults.set(false, forKey: "is24HourTimeEnabled")
        userDefaults.set(false, forKey: "isDarkModeEnabled")
//        ImageCache.clearMemoryCache()
//        ImageCache.clearDiskCache()
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "signUpPage")
        {
            //            print("peehole")
            self.present(VC, animated: true, completion: nil)
        }
    }
    
}
