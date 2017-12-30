//
//  SignInViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/7/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import GoogleSignIn
import FBSDKCoreKit
import FBSDKLoginKit
import TwitterKit

class SignInViewController: UIViewController, GIDSignInUIDelegate {

var segueInProcess = false
var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    let userDefaults = UserDefaults.standard
//    @IBOutlet weak var SignInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        if(!segueInProcess){
            let googleButton = GIDSignInButton()
            googleButton.frame = CGRect(x: 16, y: view.frame.height - 240, width: view.frame.width - 32, height: 60)
            googleButton.addTarget(self, action: #selector(GoogleSignIn), for: .touchUpInside)
            view.addSubview(googleButton)
            segueInProcess = true
        }
        let twitterButton = TWTRLogInButton(logInCompletion: { session, error in
            if let session = session {
                print("signed in as \(String(describing: session.userName))");
                let credential = TwitterAuthProvider.credential(withToken: session.authToken, secret: session.authTokenSecret)
                self.userDefaults.set("twitter", forKey: "signInMode")
                self.generalLogin(credential)
                let client = TWTRAPIClient.withCurrentUser()
                
                client.requestEmail { email, error in
                    if (email != nil) {
                        Auth.auth().currentUser?.updateEmail(to: email!) { (error) in
                            // ...
                        }
                        print("signed in as \(session.userName)");
                    } else {
                        print("error");
                    }
                }
            } else {
                print("error: \(String(describing: error?.localizedDescription))");
            }
        })
        twitterButton.frame = CGRect(x: 16, y: view.frame.height - 180, width: view.frame.width - 32, height: 60)
        self.view.addSubview(twitterButton)
        
        
        
        let emailButton = UIButton(type: .system)
        emailButton.frame = CGRect(x: 16, y: 116 + 330, width: view.frame.width - 32, height: 60)
        emailButton.setTitle("Email", for: UIControlState.normal)
//        emailButton.contentHorizontalAlignment = .left
        emailButton.backgroundColor = UIColor.red
        
        emailButton.addTarget(self, action: #selector(emailSignUp), for: .touchUpInside)
//        self.view.addSubview(emailButton)
        
//        let facebookButton = UIButton(type: .custom)
        
//        facebookButton.setImage(UIImage(named: "facebookLogInButton.png"), for: .normal)
        let facebookButton = FBSDKLoginButton()
        facebookButton.frame = CGRect(x: 16, y: view.frame.height - 110, width: view.frame.width - 32, height: 60)
        facebookButton.addTarget(self, action: #selector(facebookSignInButton), for: .touchUpInside)
        self.view.addSubview(facebookButton)

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self
//        facebookButton.delegate = self
//        fbLoginButton.delegate = self
        
        
        Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("user signed in ")
                self.alreadySignedIn(user!)
            }
            else
            {
                print("user not signed in ")
            }
        }
        

//
        if let providerID = Auth.auth().currentUser?.providerID {
//            switch providerID {
//            default:
                print("user is signed in with \(providerID)")
//            }
        }

//        if(!segueInProcess){
//        let googleButton = GIDSignInButton()
//        googleButton.frame = CGRect(x: 16, y: 116 + 66, width: view.frame.width - 32, height: 60)
//        googleButton.addTarget(self, action: #selector(GoogleSignIn), for: .touchUpInside)
//        view.addSubview(googleButton)
//        segueInProcess = true
//        }
    ref = Database.database().reference()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        // [START remove_auth_listener]
//        Auth.auth().removeStateDidChangeListener(handle!)
        // [END remove_auth_listener]
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func emailSignUp() {
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "emailSignUpPage")
        {
            self.present(VC, animated: true, completion: nil)
        }
//        self.performSegue(withIdentifier: "emailSignUp", sender: nil)
    }
    
    func GoogleSignIn(){
        if(!segueInProcess){
//        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()
        segueInProcess = true
        }
    }
    
    func alreadySignedIn(_ user: Firebase.User){
        
         self.ref.child("users").child(user.uid)
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "navTabBar")
        {
//            print("butthole")
            self.present(VC, animated: true, completion: nil)
        }
    }
    
    @IBAction func didPressFacebookSignIn(_ sender: Any) {
        
    }

    
    func facebookSignInButton() {
        let fbLoginManager = FBSDKLoginManager()
        fbLoginManager.logIn(withReadPermissions: ["public_profile", "email"], from: self) { (result, error) in
            if let error = error {
                print("Failed to login: \(error.localizedDescription)")
                return
            }
            guard let accessToken = FBSDKAccessToken.current() else {
                print("Failed to get access token")
                return
            }
            self.userDefaults.set("facebook", forKey: "signInMode")
            let credential = FacebookAuthProvider.credential(withAccessToken: accessToken.tokenString)
            self.generalLogin(credential)
            
        }
    }
    
    func generalLogin(_ credential: AuthCredential)
    {
        Auth.auth().signIn(with: credential) { (user, error) in
            if error != nil {
                // ...
                return
            }
            // User is signed in
            // ...
        }
   
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
