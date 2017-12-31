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
import SCLAlertView

class SignInViewController: UIViewController, GIDSignInUIDelegate {
    @IBOutlet weak var entryFieldViews: UIView!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailAddressTextField: UITextField!
    
    
    var segueInProcess = false
var handle: AuthStateDidChangeListenerHandle?
    var ref: DatabaseReference!
    let userDefaults = UserDefaults.standard
//    @IBOutlet weak var SignInButton: GIDSignInButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        entryFieldViews.layer.cornerRadius = 10
        if(!segueInProcess){
            let googleButton = GIDSignInButton()
            googleButton.frame = CGRect(x: 16, y: view.frame.height - 190, width: view.frame.width - 32, height: 40)
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
        twitterButton.frame = CGRect(x: 16, y: view.frame.height - 130, width: view.frame.width - 32, height: 40)
        self.view.addSubview(twitterButton)
        
        let lineView = UIView(frame: CGRect(x: view.frame.width*0.3, y: view.frame.height - 195, width: view.frame.width * 0.4, height: 1.0))
        lineView.layer.borderWidth = 1.0
        lineView.layer.borderColor = UIColor.white.cgColor
        self.view.addSubview(lineView)
        
        let emailButton = UIButton(type: .system)
        emailButton.frame = CGRect(x: 16, y: view.frame.height - 245, width: view.frame.width - 32, height: 40)
        emailButton.setTitle("Sign In", for: UIControlState.normal)
        emailButton.layer.cornerRadius = 7
//        emailButton.contentHorizontalAlignment = .left
        emailButton.backgroundColor = UIColor(red:0.93, green:0.39, blue:0.29, alpha:1.0)
        emailButton.setTitleColor(UIColor.white, for: .normal)
        emailButton.addTarget(self, action: #selector(emailSignInButtonAction), for: .touchUpInside)
        self.view.addSubview(emailButton)
        
        let resetButton = UIButton(type: .system)
        resetButton.frame = CGRect(x: 16, y: view.frame.height - 290, width: view.frame.width/2 - 32, height: 40)
        resetButton.setTitle("Reset Password", for: UIControlState.normal)
        resetButton.layer.cornerRadius = 7
        //        emailButton.contentHorizontalAlignment = .left
        resetButton.backgroundColor = UIColor(red:0.93, green:0.39, blue:0.29, alpha:1.0)
        resetButton.setTitleColor(UIColor.white, for: .normal)
        resetButton.addTarget(self, action: #selector(resetPassword), for: .touchUpInside)
        self.view.addSubview(resetButton)
        
        let createAccountButton = UIButton(type: .system)
        createAccountButton.frame = CGRect(x: view.frame.width/2, y: view.frame.height - 290, width: view.frame.width - view.frame.width/2 - 16, height: 40)
        createAccountButton.setTitle("Create Account", for: UIControlState.normal)
        createAccountButton.layer.cornerRadius = 7
        //        emailButton.contentHorizontalAlignment = .left
        createAccountButton.backgroundColor = UIColor(red:0.93, green:0.39, blue:0.29, alpha:1.0)
        createAccountButton.setTitleColor(UIColor.white, for: .normal)
        createAccountButton.addTarget(self, action: #selector(createNewAccount), for: .touchUpInside)
        self.view.addSubview(createAccountButton)
        
//        let facebookButton = UIButton(type: .custom)
        
//        facebookButton.setImage(UIImage(named: "facebookLogInButton.png"), for: .normal)
        let facebookButton = FBSDKLoginButton()
        facebookButton.frame = CGRect(x: 16, y: view.frame.height - 80, width: view.frame.width - 32, height: 40)
        facebookButton.addTarget(self, action: #selector(facebookSignInButton), for: .touchUpInside)
        self.view.addSubview(facebookButton)

        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        GIDSignIn.sharedInstance().uiDelegate = self
//        facebookButton.delegate = self
//        fbLoginButton.delegate = self
        ref = Database.database().reference()
        
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
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
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
    
    func emailSignInButtonAction() {
        if let email = self.emailAddressTextField.text, let password = self.passwordTextField.text
        {
            Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
                guard let user = user, error == nil else {
                    //                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                    //                        let alert = SCLAlertView(appearance: appearance)
                    //                        _ = alert.showError("Error", subTitle:"The email or password are incorrect.")
                    //                        //                            self.showMessagePrompt(error.localizedDescription)
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                    let alert = SCLAlertView(appearance: appearance)
                    _ = alert.showError("Empty Password/Email!", subTitle:"The password/email field can't be empty!")
                    return
                }
                
                //                self.ref.child("users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                //                    guard !snapshot.exists() else {
                if let VC = self.storyboard?.instantiateViewController(withIdentifier: "navTabBar")
                {
                    //                    print("peehole")
                    self.present(VC, animated: true, completion: nil)
                }
                
                
                //                }
                //                self.TabBarController!.SecondViewController(animated: true)
                //            })
                
                //        }
                //        else
                //        {
                //            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                //                let alert = SCLAlertView(appearance: appearance)
                //                _ = alert.showError("Empty Password/Email!", subTitle:"The password/email field can't be empty!")
                
            })
            //            self.ref.child("users").child(user.uid)
        }
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
    
    func createNewAccount(){
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        let email = alert.addTextField("Email")
        let password = alert.addTextField("Password")
        password.isSecureTextEntry = true
        _ = alert.addButton("Create New Account")
        {
            Auth.auth().createUser(withEmail: email.text!, password: password.text!) { (user, error) in
                if error != nil {
                                                let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                                                let alert = SCLAlertView(appearance: appearance)
                                                _ = alert.showError("Error", subTitle:"Are you sure you dont already have an account and the spelling is correct?")
                                                    return
                }
//                print("success")
                let userDefaults = UserDefaults.standard
                
                userDefaults.set(true, forKey: "isSignedIn")
                
                userDefaults.synchronize()
//                if let VC = self.storyboard?.instantiateViewController(withIdentifier: "signUpPage")
//                {
//                    //                            print("peeholesign up")
//                    self.present(VC, animated: true, completion: nil)
//                }
                //                         self.navigationController!.popViewController(animated: true)
            }
       
        }
        _ = alert.addButton("Cancel")
        {
            print("user canceled action.")
        }
        _ = alert.showEdit("New Account Creation", subTitle:"Enter your email and a password for your new account.")
    }
    
    func resetPassword(){
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            let email = alert.addTextField("Email")
            _ = alert.addButton("Reset Password")
            {
                Auth.auth().sendPasswordReset(withEmail: email.text!) { (error) in
                    if error != nil
                    {
//                        print("error")
                        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                        let alert = SCLAlertView(appearance: appearance)
                        _ = alert.showError("Err..", subTitle:"Are you sure that's the right email? We can't find anything with it...")
                        return

                    }
                    
                    let Sappearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                    let Salert = SCLAlertView(appearance: Sappearance)
                    _ = Salert.showSuccess("Email Sent!", subTitle:"A link to reset your password has been sent to the email you provided!")
                    
                }
            }
            _ = alert.addButton("Cancel")
            {
                print("user canceled action.")
            }
            _ = alert.showEdit("Forgot your Password?", subTitle:"Enter your email below and we'll send you a link to reset it!")
//            if let email = email.text
//            {
//                Auth.auth().sendPasswordReset(withEmail: email) { (error) in
//                    if error != nil
//                    {
//                        let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
//                        let alert = SCLAlertView(appearance: appearance)
//                        _ = alert.showError("Err..", subTitle:"Are you sure that's the right email? We can't find anything with it...")
//                        return
//                    }
//
//                    let Sappearance = SCLAlertView.SCLAppearance(showCloseButton: true)
//                    let Salert = SCLAlertView(appearance: Sappearance)
//                    _ = Salert.showSuccess("Email Sent!", subTitle:"A link to reset your password has been sent to the email you provided!")
                    //                            self.showMessagePrompt("Sent")
                    //                        }
                    //                        // [END_EXCLUDE]
//                }
                //                    // [END password_reset]
//            }
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
