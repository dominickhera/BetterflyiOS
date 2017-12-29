//
//  Onboarding.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/1/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
///Users/Dominick/Desktop/Betterfly/Betterfly

import UIKit
import paper_onboarding

class ViewController: UIViewController, PaperOnboardingDataSource, PaperOnboardingDelegate {
    
    @IBOutlet weak var onboardingView: OnboardingView!
    
//    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var getStartedButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        onboardingView.dataSource = self
        onboardingView.delegate = self
        
        
    }
    
    
    func onboardingItemsCount() -> Int {
        return 3
    }
    
    func onboardingItemAtIndex(_ index: Int) -> OnboardingItemInfo {
        let backgroundColorTwo = UIColor(red: 37/255, green: 116/255, blue: 169/255, alpha: 1)
        let backgroundColorOne = UIColor(red: 58/255, green: 83/255, blue: 155/255, alpha: 1)
        let backgroundColorThree = UIColor(red: 3/255, green: 201/255, blue: 169/255, alpha: 1)
        
        let titleFont = UIFont(name: "AvenirNext-Bold", size: 24)!
        let descirptionFont = UIFont(name: "AvenirNext-Regular", size: 18)!
        
        return [("cloud", "Bad Days Happen", "Sometimes bad days happen and we lose sight of all the positive things that happen in our life.", "", backgroundColorOne, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                ("sun", "Remember the Good Times", "Every time something good happens, jot it down in Betterfly. When you’re feeling down, you can go through your collection and remember all the little things that make life worth living.", "", backgroundColorTwo, UIColor.white, UIColor.white, titleFont, descirptionFont),
                
                ("createIcon", "Start Writing", "Ready to start collecting good thoughts?", "", backgroundColorThree, UIColor.white, UIColor.white, titleFont, descirptionFont)][index]
        
        
        
    }
    
    
    
    func onboardingConfigurationItem(_ item: OnboardingContentViewItem, index: Int) {
        
    }
    
    
    
    func onboardingWillTransitonToIndex(_ index: Int) {
        if index == 1 {
            
            if self.getStartedButton.alpha == 1 {
                UIView.animate(withDuration: 0.2, animations: {
                    self.getStartedButton.alpha = 0
//                    self.logInButton.alpha = 0
                })
            }
            
        }
    }
    
    func onboardingDidTransitonToIndex(_ index: Int) {
        if index == 2 {
            UIView.animate(withDuration: 0.4, animations: {
                self.getStartedButton.alpha = 1
//                self.logInButton.alpha = 1
            })
        }
    }
    
    
    
    @IBAction func gotStarted(_ sender: Any) {
        
        let userDefaults = UserDefaults.standard
        
        userDefaults.set(true, forKey: "onboardingComplete")
        
        userDefaults.synchronize()
        
    }
    
    
    
//    @IBAction func logIn(_ sender: Any) {
    
//        let userDefaults = UserDefaults.standard
//        
//        userDefaults.set(true, forKey: "onboardingComplete")
//        
//        userDefaults.synchronize()
//    }
    
    
    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}


