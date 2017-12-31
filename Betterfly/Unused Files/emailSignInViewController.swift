
//  emailSignInViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/7/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import SCLAlertView

class emailSignInViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    var ref: DatabaseReference!
    
        override func viewDidLoad() {
            super.viewDidLoad()

                // Do any additional setup after loading the view.
        }
    
    override func viewDidAppear(_ animated: Bool) {
//        if Auth.auth().currentUser != nil {
//            self.performSegue(withIdentifier: "signIn", sender: nil)
//        }
        ref = Database.database().reference()
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            // Dispose of any resources that can be recreated.
    }

    @IBAction func didPressSignIn(_ sender: Any)
    {
        if let email = self.emailTextField.text, let password = self.passwordTextField.text
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

@IBAction func didForgetPassword(_ sender: Any)
{

    let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        let email = alert.addTextField("Email")
        _ = alert.addButton("Reset Password")
        {
            Auth.auth().sendPasswordReset(withEmail: email.text!) { (error) in
                if error != nil
                {
                    print("error")
                }

            }
        }
    _ = alert.addButton("Cancel")
    {
        print("user canceled action.")
    }
    _ = alert.showEdit("Forgot your Password?", subTitle:"Enter your email below and we'll send you a link to reset it!")
        if let email = email.text
        {
            Auth.auth().sendPasswordReset(withEmail: email) { (error) in
                if error != nil
                {
                    let appearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                        let alert = SCLAlertView(appearance: appearance)
                        _ = alert.showError("Err..", subTitle:"Are you sure that's the right email? We can't find anything with it...")
                        return
                }

            let Sappearance = SCLAlertView.SCLAppearance(showCloseButton: true)
                let Salert = SCLAlertView(appearance: Sappearance)
                _ = Salert.showSuccess("Email Sent!", subTitle:"A link to reset your password has been sent to the email you provided!")
                //                            self.showMessagePrompt("Sent")
                //                        }
                //                        // [END_EXCLUDE]
                                    }
                //                    // [END password_reset]
                                }
}

@IBAction func didPressSignUp(_ sender: Any)
{
//    self.performSegue(withIdentifier: "signIn2SignUp", sender: nil)
    if let VC = self.storyboard?.instantiateViewController(withIdentifier: "emailSignUpPage")
    {
//        print("peehole")
        self.present(VC, animated: true, completion: nil)
    }
}
@IBAction func didPressCancelEmailSignIn(_ sender: Any)
{
//    self.performSegue(withIdentifier: "signIn2SignInMenu", sender: nil)
    if let VC = self.storyboard?.instantiateViewController(withIdentifier: "signUpPage")
    {
//        print("peehole")
        self.present(VC, animated: true, completion: nil)
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

