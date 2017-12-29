//
//  ThirdPartyCreditWebViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/23/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit

class ThirdPartyCreditWebViewController: UIViewController {

    @IBOutlet weak var myWebView: UIWebView!
    var url = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("credit URL is \(url)")
//        let url = URLRequest(url: creditURL)
//        myWebView.loadRequest(URLRequest(url: url!))
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
