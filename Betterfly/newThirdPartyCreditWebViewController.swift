//
//  newThirdPartyCreditWebViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 1/1/18.
//  Copyright © 2018 Dominick Hera. All rights reserved.
//

import UIKit

class newThirdPartyCreditWebViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    
    var urlString = ""
    var titleString = ""
    override func viewDidLoad() {
        super.viewDidLoad()
//        print("test: \(urlString)")
        self.title = titleString
        let url = URL(string: urlString)
        myWebView.loadRequest(URLRequest(url: url!))
        // Do any additional setup after loading the view.
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
