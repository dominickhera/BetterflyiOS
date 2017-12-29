//
//  AboutMeViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 9/5/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit

class AboutMeViewController: UIViewController {

    @IBOutlet weak var profilePictureView: UIImageView!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
         self.tabBarController?.tabBar.isHidden = true
        self.profilePictureView.image =  UIImage(named:"profilePicture")
        self.profilePictureView.layer.cornerRadius = self.profilePictureView.frame.size.width / 2
        self.profilePictureView.clipsToBounds = true
        self.profilePictureView.layer.borderWidth = 8.0
        self.profilePictureView.layer.borderColor = UIColor.white.cgColor
        self.descriptionTextView.textColor = UIColor.white
        descriptionTextView.text = "Hi! I'm Dominick, a 3rd year university student majoring in Software Engineering with a minor in Political Science. I hope that you, as the user, enjoy it as much as I do!"
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
//         descriptionTextView.font = UIFont(name:"SF-UI-Text-Semibold", size:30)
        // Do any additional setup after loading the view.
    }

    @IBAction func openTwitterWeb(_ sender: Any) {
        let url = URL(string: "https://twitter.com/dherasy")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
            // Fallback on earlier versions
        }
    }
    
    @IBAction func openLinkedInWeb(_ sender: Any) {
        let url = URL(string: "https://www.linkedin.com/in/dominickhera/")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
            // Fallback on earlier versions
        }
    }
    
    @IBAction func openInstagramWeb(_ sender: Any) {
        let url = URL(string: "https://www.instagram.com/tehcanadiantaco/")!
        if #available(iOS 10.0, *) {
            UIApplication.shared.open(url, options: [:])
        } else {
            UIApplication.shared.openURL(url)
            // Fallback on earlier versions
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
