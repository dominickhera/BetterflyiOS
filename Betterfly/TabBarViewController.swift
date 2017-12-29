//
//  TabBarViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/8/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController {

    @IBInspectable var defaultIndex: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        selectedIndex = defaultIndex
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
