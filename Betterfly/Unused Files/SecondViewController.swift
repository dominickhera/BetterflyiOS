//
//  SecondViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 7/31/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Photos
import Firebase
import SCLAlertView


class SecondViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var ref: DatabaseReference!
    var storageRef: StorageReference!
    var camCheck = false
//    var tempInfo
    
    @IBOutlet weak var removeImagePost: UIButton!
    @IBOutlet var toolBarView: UIView!
    @IBOutlet var addPostView: UIView!
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
//    var handle: AuthStateDidChangeListenerHandle?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.ref = Database.database().reference()
        storageRef = Storage.storage().reference()
        addPostView.layer.cornerRadius = 10
        bodyTextView.inputAccessoryView = toolBarView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        postImageView.isUserInteractionEnabled = false
        postImageView.addGestureRecognizer(tapGestureRecognizer)
        postImageView.isHidden = true
        postImageView.layer.cornerRadius = 5
        removeImagePost.isHidden = true
      //  Auth.auth().addStateDidChangeListener { (auth, user) in
        //    if let user = user {
          //      let uid = user.uid
            //    let email = user.email
              //  print("\n\nemail: \(email!), uid: \(uid)\n\n")
            //}
            //else
           // {
             //     print("\nsigned out\n")
//                self.notSignedIn()
               // }
        //}
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func viewDidAppear(_ animated: Bool) {

        Auth.auth().addStateDidChangeListener { (auth, user) in
            if let user = user {
                let uid = user.uid
//                let email = user.email
                print("\n\nuid: \(uid)\n\n")
            }
            else
            {
                print("\nsigned out\n")
                self.notSignedIn()
            }
        }
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
//        let tappedImage = tapGestureRecognizer.view as! UIImageView
       
                let imageView = tapGestureRecognizer.view as! UIImageView
                let newImageView = UIImageView(image: imageView.image)
//                newImageView.frame = UIScreen.main.bounds
                newImageView.backgroundColor = .black
                newImageView.contentMode = .scaleAspectFit
                newImageView.frame = UIScreen.main.bounds
                newImageView.isUserInteractionEnabled = true
                let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
                newImageView.addGestureRecognizer(tap)
                self.view.addSubview(newImageView)
                self.navigationController?.isNavigationBarHidden = true
                self.tabBarController?.tabBar.isHidden = true
        
        // Your action
    }
    
    func notSignedIn(){
        
        if let VC = self.storyboard?.instantiateViewController(withIdentifier: "signUpPage")
        {
            self.present(VC, animated: true, completion: nil)
        }
    }
    
    @IBAction func addPictureToPost(_ sender: Any) {
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .camera
        } else {
            picker.sourceType = .photoLibrary
        }
        present(picker, animated: true, completion:nil)
    }
    @IBAction func addPictureFromLibrary(_ sender: Any) {
        
        let picker = UIImagePickerController()
        picker.delegate = self
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            picker.sourceType = .photoLibrary
        } else {
            picker.sourceType = .camera
        }
        present(picker, animated: true, completion:nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true, completion:nil)
        
        var chosenImage = UIImage()
        chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage //2
        postImageView.contentMode = .scaleAspectFill //3
        postImageView.image = chosenImage
        postImageView.isUserInteractionEnabled = true
        postImageView.isHidden = false
        removeImagePost.isHidden = false

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func blurIn() {
        self.view.addSubview(addPostView)
        addPostView.center = self.view.center
//        self.blurEffect.isUserInteractionEnabled = true
        
        addPostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addPostView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
//            self.blurEffect.effect = self.blur
            self.addPostView.alpha = 1
            self.addPostView.transform = CGAffineTransform.identity
        }
        self.tabBarController?.tabBar.isHidden = true
        
    }
    
    func blurOut() {
        UIView.animate(withDuration: 0.3, animations: {
            self.addPostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.addPostView.alpha = 0
            
//            self.blurEffect.effect = nil
//            self.blurEffect.isUserInteractionEnabled = false
        }) { (success:Bool) in
            self.addPostView.removeFromSuperview()
        }
         self.tabBarController?.tabBar.isHidden = false
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
        bodyTextView.text = ""
//        let tapPhotoGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapPhotoGestureRecognizer:)))
//        postImageView.isUserInteractionEnabled = true
//        postImageView.addGestureRecognizer(tapPhotoGestureRecognizer)
        blurIn()
        bodyTextView.becomeFirstResponder()
    }
    
    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
//        self.navigationController?.isNavigationBarHidden = false
//        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func didTapShare(_ sender: AnyObject) {
        let userID = Auth.auth().currentUser?.uid
        let key = ref.child("posts").childByAutoId().key
        let body = bodyTextView.text
//        let title = titleTextField.text
        let nsDate = NSDate()
//        let postDate = ("\(nsDate)")
        let calendar = NSCalendar.current
        let year = calendar.component(.year, from: nsDate as Date)
        let month = calendar.component(.month, from: nsDate as Date)
        let day = calendar.component(.day, from: nsDate as Date)
        let hour = calendar.component(.hour, from: nsDate as Date)
        let minutes = calendar.component(.minute, from: nsDate as Date)
        let postHour = "\(hour)"
        var postMinutes = "\(minutes)"
        
        if (Int(postMinutes)! < 10)
        {
            postMinutes = "0\(minutes)"
        }
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
//        let utcTimeZoneStr = formatter.string(from: date)
//        let timestamp = (Date().timeIntervalSince1970 as NSString).doubleValue
        let timeStamp = "\(Date().timeIntervalSince1970)"
        let doubleTimeStamp = Double(timeStamp)
        let reversedTimestamp = -1.0 * doubleTimeStamp!
        let realReverseTimeStamp = "\(reversedTimestamp)"
//        let seconds = calendar.component(.second, from: date as Date)
        let postDate = ("\(month)-\(day)-\(year)")
        let postMonth = ("\(month)")
         let postDay = ("\(day)")
         let postYear = ("\(year)")
        let time = ("\(hour):\(postMinutes)")
        var downloadURL = ""
        
        if postImageView.image != nil {
        var data = Data()
        data = UIImageJPEGRepresentation(postImageView.image!, 0.8)!
        // set upload path
        let filePath = "users/" + Auth.auth().currentUser!.uid + "/\(key).jpg"
        let metaData = StorageMetadata()
        metaData.contentType = "image/jpeg"
        self.storageRef.child(filePath).putData(data, metadata: metaData){(metaData,error) in
            if let error = error {
                print(error.localizedDescription)
                return
            }else{
                //store downloadURL
                let photoURL = metaData!.downloadURL()!.absoluteString
                downloadURL = photoURL
//                print("download url: \(downloadURL), photourl: \(photoURL)")
//                print("download url is now: \(downloadURL)")
                print("\(date)")
                let post = ["uid": userID,
                            "month": postMonth,
                            "day": postDay,
                            "year": postYear,
                            "time": time,
                            "date": postDate,
                            "hour": postHour,
                            "minutes": postMinutes,
                            "timeStamp": timeStamp,
                            "reverseTimeStamp": realReverseTimeStamp,
                            "downloadURL": photoURL,
                            "body": body]
                
                print("\(userID!)")
                let childUpdates = ["/users/\(userID!)/\(key)/": post]
                self.ref.updateChildValues(childUpdates)
                //store downloadURL at database
            }
        }
        }
        else{
            print("download url is now: \(downloadURL)")
            print("\(date)")
            let post = ["uid": userID,
                        "month": postMonth,
                        "day": postDay,
                        "year": postYear,
                        "time": time,
                        "date": postDate,
                        "hour": postHour,
                        "minutes": postMinutes,
                        "timeStamp": timeStamp,
                        "reverseTimeStamp": realReverseTimeStamp,
                        "downloadURL": downloadURL,
                        "body": body]
            
            print("\(userID!)")
            let childUpdates = ["/users/\(userID!)/\(key)/": post]
            self.ref.updateChildValues(childUpdates)
        }
        
//        print("download url is now: \(downloadURL)")
//        print("\(date)")
//        let post = ["uid": userID,
//                    "month": postMonth,
//                    "day": postDay,
//                    "year": postYear,
//                    "time": time,
//                    "date": postDate,
//                    "timeStamp": timeStamp,
//                    "reverseTimeStamp": realReverseTimeStamp,
//                    "downloadURL": downloadURL,
//                    "body": body]
//
//        print("\(userID!)")
//        let childUpdates = ["/users/\(userID!)/\(key)/": post]
//        ref.updateChildValues(childUpdates)
        postImageView.image = nil
        postImageView.isUserInteractionEnabled = false
        postImageView.isHidden = true
        blurOut()
//            self.ref.child("users/\(userID!)/\(date)").setValue(post)
    }
    @IBAction func removeImagePost(_ sender: Any) {
        self.view.endEditing(true)
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Delete Image")
        {
            self.postImageView.image = nil
            self.postImageView.isUserInteractionEnabled = false
            self.postImageView.isHidden = true
            self.removeImagePost.isHidden = true
//            self.blurOut()
        }
        _ = alert.addButton("Cancel")
        {
            self.bodyTextView.becomeFirstResponder()
            print("user canceled action.")
        }
        _ = alert.showWarning("Delete attached Image?", subTitle:"Don't worry, you can always add a picture to your post later.")
        
        
    }
    
    @IBAction func cancelStatus(_ sender: Any) {
        self.view.endEditing(true)
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Delete Post")
        {
            self.postImageView.image = nil
            self.postImageView.isUserInteractionEnabled = false
            self.postImageView.isHidden = true
            self.blurOut()
        }
        _ = alert.addButton("Cancel")
        {
            self.bodyTextView.becomeFirstResponder()
            print("user canceled action.")
        }
        _ = alert.showWarning("Delete current post?", subTitle:"If you cancel now, you'll lose all the information you just wrote out!")

//        blurOut()
        print("user canceled status entry")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

