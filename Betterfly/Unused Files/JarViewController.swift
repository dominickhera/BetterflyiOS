//
//  JarViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/12/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
//import CloudKit
import CoreMotion
import Firebase

class JarViewController: UIViewController {
    
    
    
    @IBOutlet weak var blurEffect: UIVisualEffectView!
    //    @IBOutlet var dailyPostBox: UITextView!
    @IBOutlet var addPostView: UIView!
    @IBOutlet weak var promptStatusButton: UIButton!
    @IBOutlet weak var statusBox: UITextView!
    @IBOutlet weak var entryDate: UILabel!
    
    
    var ref: DatabaseReference!
    var paper:UIImageView!
    var speedX:UIAccelerationValue=0
    var speedY:UIAccelerationValue=0
    
    
    //    var status = [CKRecord]()
//    let privateDataBase = CKContainer.default().privateCloudDatabase
    
    let motionManager = CMMotionManager()
    var timer: Timer!
    var blur:UIVisualEffect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        
        blur = blurEffect.effect
        blurEffect.effect = nil
        addPostView.layer.cornerRadius = 10
        //        dailyPostBox.layer.cornerRadius = 10
        promptStatusButton.layer.cornerRadius = 10
        //        dailyPostBox.text = "Today I saw a dog!"
        //        dailyPostBox.isUserInteractionEnabled = true
        //        let shareDailyPostSelector : Selector = #selector(JarVC.shareDaily)
        //        let shareGesture = UITapGestureRecognizer(target: self, action: shareDailyPostSelector)
        //        shareGesture.numberOfTapsRequired = 1
        //        dailyPostBox.addGestureRecognizer(shareGesture)
        
        paper=UIImageView(image:UIImage(named:"paper"))
        paper.frame=CGRect(x: 00, y: 0, width: 75, height: 50)
        paper.center=self.view.center
        self.view.addSubview(paper)
        self.blurEffect.isUserInteractionEnabled = false
        
        
        motionManager.accelerometerUpdateInterval = 1/60
        
        if(motionManager.isAccelerometerAvailable)
        {
            let queue = OperationQueue.current
            motionManager.startAccelerometerUpdates(to: queue!, withHandler: { (accelerometerData, error) in
                
                self.speedX += accelerometerData!.acceleration.x
                self.speedY +=  accelerometerData!.acceleration.y
                var posX=self.paper.center.x + CGFloat(self.speedX)
                var posY=self.paper.center.y - CGFloat(self.speedY)
                
                if posX<0 {
                    posX=0;
                    
                    //                    self.speedX *= -0.000001
                    self.speedY*=0.5
                    
                }else if posX > self.view.bounds.size.width {
                    posX=self.view.bounds.size.width
                    
                    //                    self.speedX *= -0.4
                    self.speedX*=0.5
                }
                if posY<0 {
                    posY=0
                    
                    self.speedY=0
                } else if posY>self.view.bounds.size.height{
                    posY=self.view.bounds.size.height
                    
                    self.speedY *= 0.3
                    //                    self.speedY=0
                }
                self.paper.center=CGPoint(x: posX, y: posY)
                
                
            })
            
            // Do any additional setup after loading the view, typically from a nib.
        }
        
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    //    func shareDaily(){
    //        let activityViewController = UIActivityViewController(activityItems: [dailyPostBox.text], applicationActivities: nil)
    //        present(activityViewController, animated: true, completion: {})
    //    }
    
    func blurIn() {
        self.view.addSubview(addPostView)
        addPostView.center = self.view.center
        self.blurEffect.isUserInteractionEnabled = true
        
        addPostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addPostView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            self.blurEffect.effect = self.blur
            self.addPostView.alpha = 1
            self.addPostView.transform = CGAffineTransform.identity
        }
    }
    
    func blurOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.addPostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addPostView.alpha = 0
            
            self.blurEffect.effect = nil
            self.blurEffect.isUserInteractionEnabled = false
        }) { (success:Bool) in
            self.addPostView.removeFromSuperview()
        }
    }
    
    @IBAction func promptStatusBox(_ sender: Any) {
        let date = NSDate()
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: date as Date)
        let month = calendar.component(.month, from: date as Date)
        let day = calendar.component(.day, from: date as Date)
        //        let hour = calendar.component(.hour, from: date as Date)
        //        let minutes = calendar.component(.minute, from: date as Date)
        var realMonth = "Month"
        
        switch(month){
        case 1:
            realMonth = "January"
        case 2:
            realMonth = "February"
        case 3:
            realMonth = "March"
        case 4:
            realMonth = "April"
        case 5:
            realMonth = "May"
        case 6:
            realMonth = "June"
        case 7:
            realMonth = "July"
        case 8:
            realMonth = "August"
        case 9:
            realMonth = "September"
        case 10:
            realMonth = "October"
        case 11:
            realMonth = "November"
        case 12:
            realMonth = "December"
        default:
            realMonth = "Error"
            
        }
        
        //        if(hour < 12 || hour == 24) {
        //            entryDate.text = "\(realMonth) \(day), \(year) - \(hour):\(minutes) am"
        //        }
        //        else {
        //            entryDate.text = "\(realMonth) \(day), \(year) - \(hour):\(minutes) pm"
        //        }
        entryDate.text = "\(realMonth) \(day), \(year)"
        statusBox.text = ""
        blurIn()
        statusBox.becomeFirstResponder()
    }
    
    @IBAction func postStatus(_ sender: AnyObject) {
        blurOut()
        print("user entered: \(statusBox.text!)")
        
        let userID = Auth.auth().currentUser?.uid
        
        
//        ref.child("users").child(userID!).observeSingleEvent(of: .value, with: { (snapshot) in
//            // Get user value
//            let value = snapshot.value as? NSDictionary
//            let username = value?["username"] as? String ?? ""
//            let user = User.init(username: user)
//
//            // [START_EXCLUDE]
//            // Write new post
          
//        let store = CKRecord(recordType: "Message")
        
            
            self.writeNewPost(withUserID: userID!, title: self.entryDate.text!, body: self.statusBox.text)
            
//        store.setObject(statusBox.text as CKRecordValue?, forKey: "Status")
//
//        privateDataBase.save(store) { (saveRecord, error) in
//            if error != nil {
//                print("error saving Data on CloudKit.. --->" + (error?.localizedDescription)!)
//            }else{
//                print("data saved successfully")
//            }
//        }
        
    }
    
    
    
    @IBAction func cancelStatus(_ sender: Any) {
        blurOut()
        print("user canceled status entry")
    }
//}

func writeNewPost(withUserID userID: String, title: String, body: String) {
    // Create new post at /user-posts/$userid/$postid and at
    // /posts/$postid simultaneously
    // [START write_fan_out]
    let key = ref.child("posts").childByAutoId().key
    let post = ["uid": userID,
                "title": title,
                "body": body]
    let childUpdates = ["/posts/\(key)": post,
                        "/user-posts/\(userID)/\(key)/": post]
    ref.updateChildValues(childUpdates)
    // [END write_fan_out]
}
//
//func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//    textField.resignFirstResponder()
//    return false
//}


}
