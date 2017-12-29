//
//  emailSignUpViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/7/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class emailSignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didPressSignUp(_ sender: Any) {
        if let email = emailTextField.text {
            if let password = passwordTextField.text {
                    Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
                        if error != nil {
//                            let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
//                            let alert = SCLAlertView(appearance: appearance)
//                            _ = alert.showError("Error", subTitle:"Are you sure you dont already have an account and the spelling is correct?")
//                                return
                            }
                        print("success")
                        let userDefaults = UserDefaults.standard
                        
                        userDefaults.set(true, forKey: "isSignedIn")
                        
                        userDefaults.synchronize()
                        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "signUpPage")
                        {
//                            print("peeholesign up")
                            self.present(VC, animated: true, completion: nil)
                        }
//                         self.navigationController!.popViewController(animated: true)
                        }
            } else {
                       let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                       let alert = SCLAlertView(appearance: appearance)
                       _ = alert.showError("Empty Password!", subTitle:"The password field can't be empty!")
            }
        } else {
               let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                         let alert = SCLAlertView(appearance: appearance)
                         _ = alert.showError("Empty Email!", subTitle:"The Email field can't be empty!")
        }
}


@IBAction func didPressSignIn(_ sender: Any) {
//    self.performSegue(withIdentifier: "signUp2SignIn", sender: nil)
    if let VC = self.storyboard?.instantiateViewController(withIdentifier: "emailSignInPage")
    {
        self.present(VC, animated: true, completion: nil)
    }
}

@IBAction func didPressCancelEmailSignUp(_ sender: Any) {
    if let VC = self.storyboard?.instantiateViewController(withIdentifier: "signUpPage")
    {
        self.present(VC, animated: true, completion: nil)
    }
//    self.performSegue(withIdentifier: "signInPage", sender: nil)
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
