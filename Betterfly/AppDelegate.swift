//
//  AppDelegate.swift
//  Betterfly
//
//  Created by Dominick Hera on 7/31/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuthUI
import FirebaseGoogleAuthUI
//import FirebaseFacebookAuthUI
import GoogleSignIn
//import FBSDKCoreKit
import FBSDKLoginKit
import Bolts
import Fabric
import TwitterKit
import IQKeyboardManagerSwift
import paper_onboarding
import Crashlytics
import FirebasePerformance

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {
    
    
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        IQKeyboardManager.sharedManager().enable = true
        
        //        Fabric.with([Twitter.self])
        
        FirebaseApp.configure()
//        let authUI = FUIAuth.defaultAuthUI()
        // You need to adopt a FUIAuthDelegate protocol to receive callback
//        authUI?.delegate = self as? FUIAuthDelegate
        
        Database.database().isPersistenceEnabled = true
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        TWTRTwitter.sharedInstance().start(withConsumerKey:"opXb4omBw469uSEWDHEKxeUSf", consumerSecret:"b0bI0LmBRXFEXs0s7li1RwkXwQhq6wtyONmafPAHDhr7koZ4ss")
        FBSDKApplicationDelegate.sharedInstance().application(application, didFinishLaunchingWithOptions: launchOptions)
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        let sb = UIStoryboard(name: "Main", bundle: nil)
        var initialViewController = sb.instantiateViewController(withIdentifier: "Onboarding")
        
        let userDefaults = UserDefaults.standard
        
        if userDefaults.bool(forKey: "onboardingComplete") {
//            if userDefaults.bool(forKey: "isSignedIn") {
//                initialViewController = sb.instantiateViewController(withIdentifier: "navTabBar")
//            }
            initialViewController = sb.instantiateViewController(withIdentifier: "signUpPage")
            
        }
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if  user != nil {
                initialViewController = sb.instantiateViewController(withIdentifier: "navTabBar")
            }
            else
            {
                initialViewController = sb.instantiateViewController(withIdentifier: "signUpPage")
            }
        }
        
        
        window?.rootViewController = initialViewController
        window?.makeKeyAndVisible()
        
        //        let key = Bundle.main.object(forInfoDictionaryKey: "opXb4omBw469uSEWDHEKxeUSf"),
        //        secret = Bundle.main.object(forInfoDictionaryKey: "b0bI0LmBRXFEXs0s7li1RwkXwQhq6wtyONmafPAHDhr7koZ4ss")
        //        if let key = key as? String, let secret = secret as? String, !key.isEmpty && !secret.isEmpty {
        //            Twitter.sharedInstance().start(withConsumerKey: key, consumerSecret: secret)
        //        }
        ////
        // Override point for customization after application launch.
        return true
    }
    
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any])
        -> Bool {
            let userDefaults = UserDefaults.standard
            if GIDSignIn.sharedInstance().handle(url,
                                                 sourceApplication:options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: [:]) {
                return true
            }
            
            if (userDefaults.string(forKey: "signInMode") == "facebook") {
                return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, options: options)
            }
            
            if (userDefaults.string(forKey: "signInMode") == "twitter") {
                return TWTRTwitter.sharedInstance().application(application, open: url, options: options)
            }
            return TWTRTwitter.sharedInstance().application(application, open: url, options: options)
    }
    
    
    func application(_ application: UIApplication, open url: URL, sourceApplication: String?, annotation: Any) -> Bool {
        
        
        
        if GIDSignIn.sharedInstance().handle(url,
                                             sourceApplication: sourceApplication,
                                             annotation: annotation){
            return true
        }
        return FBSDKApplicationDelegate.sharedInstance().application(application, open: url, sourceApplication: sourceApplication, annotation: annotation)
    }
    
    
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error?) {
        if error != nil {
            //        print("sheeeeeet")
            return
        }
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                //            print("shit going down fam")
                return
            }
            // User is signed in
        }
        
    }
    
    func facebookButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError?) {
        if let error = error {
            print(error.localizedDescription)
            return
        }
        // ...
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
    
    
}
