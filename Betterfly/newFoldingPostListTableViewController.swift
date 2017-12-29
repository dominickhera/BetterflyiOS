//
//  newFoldingPostListTableViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/25/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import FoldingCell
import Firebase
import FirebaseDatabaseUI
import Photos
import SCLAlertView
import CircleMenu
import Crashlytics

class newFoldingPostListTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var storageRef: StorageReference!
    var camCheck = false
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    @IBOutlet weak var removeImagePost: UIButton!
    @IBOutlet var toolBarView: UIView!
    @IBOutlet var addPostView: UIView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    let kCloseCellHeight: CGFloat = 108
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10000
    var cellHeights: [CGFloat] = []
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.keepSynced(true)
        self.tabBarController?.tabBar.isHidden = false
        storageRef = Storage.storage().reference()
        addPostView.layer.cornerRadius = 10
        bodyTextView.inputAccessoryView = toolBarView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        postImageView.isUserInteractionEnabled = false
        postImageView.addGestureRecognizer(tapGestureRecognizer)
        
        postImageView.isHidden = true
        postImageView.layer.cornerRadius = 5
        removeImagePost.isHidden = true
        dataSource = FUITableViewDataSource.init(query: (getQuery())) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingTableViewCell
            guard let post = Post.init(snapshot: snap) else { return cell }
            if self.userDefaults.bool(forKey: "isDarkModeEnabled"){
                cell.openBodyTextView?.textColor = UIColor.white
                cell.closedBodyTextView?.textColor = UIColor.white
                cell.closedFullDateLabel?.textColor = UIColor.white
                cell.openDateBackgroundView?.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
                cell.foregroundView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                cell.barContainerView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                cell.containerView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                cell.firstImageContainerView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                cell.secondContainerView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)

            }
            else
            {
                cell.openBodyTextView?.textColor = UIColor.black
                cell.closedBodyTextView?.textColor = UIColor.black
                cell.closedFullDateLabel?.textColor = UIColor.black
                cell.openDateBackgroundView?.backgroundColor = UIColor(red:0.58, green:0.49, blue:0.69, alpha:1.0)
                cell.barContainerView.backgroundColor = UIColor(red:0.58, green:0.49, blue:0.69, alpha:1.0)
                cell.foregroundView.backgroundColor = UIColor.white
                cell.containerView.backgroundColor = UIColor.white
                cell.firstImageContainerView.backgroundColor = UIColor.white
                cell.secondContainerView.backgroundColor = UIColor.white
            }
            cell.openBodyTextView?.text = post.body
            cell.openDateLabel?.text = post.day

            let month = Int(post.month)
            var realMonth = "Month"

            switch(month){
            case 1?:
                realMonth = "January"
            case 2?:
                realMonth = "February"
            case 3?:
                realMonth = "March"
            case 4?:
                realMonth = "April"
            case 5?:
                realMonth = "May"
            case 6?:
                realMonth = "June"
            case 7?:
                realMonth = "July"
            case 8?:
                realMonth = "August"
            case 9?:
                realMonth = "September"
            case 10?:
                realMonth = "October"
            case 11?:
                realMonth = "November"
            case 12?:
                realMonth = "December"
            default:
                realMonth = "Error"

            }

            var tempHour = Int(post.hour)
            if self.userDefaults.bool(forKey: "is24HourTimeEnabled") {
                cell.openTimeLabel?.text = "\(post.hour):\(post.minutes)"
//                cell.openBodyTextView?.textColor = UIColor.gray
            }
            else
            {
//                cell.openBodyTextView?.textColor = UIColor.black
                if(tempHour! > 12 && tempHour! != 24)
                {
                    tempHour! = tempHour! - 12
                    let tempLabelHour = "\(tempHour!)"
                    cell.openTimeLabel?.text = "\(tempLabelHour):\(post.minutes) PM"
                }
                else
                {
                    cell.openTimeLabel?.text = "\(post.hour):\(post.minutes) AM"
                }
            }

            cell.openMonthLabel?.text = realMonth
            cell.closedFullDateLabel?.text = "\(realMonth) \(post.day), \(post.year)"
            cell.closedBodyTextView?.text = post.body
//            let urlCheck: String! = post.downloadURL
            if(String(post.downloadURL) != "")
            {
                let photoRef = self.storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(snap.key).jpg")
                print("photo ref is \(photoRef)\n\n")
    //                    let imageView: UIImageView = imageTableViewCell!.postImageView
                cell.openImageView!.sd_setImage(with: photoRef)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.self.imageTapped(tapGestureRecognizer:)))
                cell.openImageView!.addGestureRecognizer(tapGestureRecognizer)
            }
            else
            {

                cell.openImageView.image = nil
                cell.openImageView.isHidden = true
//                cell.firstImageContainerView!.isHidden = true
            }

            return cell
        }

        dataSource?.bind(to: tableView)
//        reloadFirebaseData()
        tableView.delegate = self
        setup()
    
    }
    
    func reloadFirebaseData() {
        dataSource = FUITableViewDataSource.init(query: (getQuery())) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingTableViewCell
            guard let post = Post.init(snapshot: snap) else { return cell }
            if self.userDefaults.bool(forKey: "isDarkModeEnabled"){
                cell.openBodyTextView?.textColor = UIColor.white
                cell.closedBodyTextView?.textColor = UIColor.white
                cell.closedFullDateLabel?.textColor = UIColor.white
                cell.openDateBackgroundView?.backgroundColor = UIColor(red:0.17, green:0.24, blue:0.31, alpha:1.0)
                cell.foregroundView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                cell.barContainerView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                cell.containerView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                cell.firstImageContainerView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                cell.secondContainerView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
                
            }
            else
            {
                cell.openBodyTextView?.textColor = UIColor.black
                cell.closedBodyTextView?.textColor = UIColor.black
                cell.closedFullDateLabel?.textColor = UIColor.black
                cell.openDateBackgroundView?.backgroundColor = UIColor(red:0.58, green:0.49, blue:0.69, alpha:1.0)
                cell.barContainerView.backgroundColor = UIColor(red:0.58, green:0.49, blue:0.69, alpha:1.0)
                cell.foregroundView.backgroundColor = UIColor.white
                cell.containerView.backgroundColor = UIColor.white
                cell.firstImageContainerView.backgroundColor = UIColor.white
                cell.secondContainerView.backgroundColor = UIColor.white
            }
            cell.openBodyTextView?.text = post.body
            cell.openDateLabel?.text = post.day
            
            let month = Int(post.month)
            var realMonth = "Month"
            
            switch(month){
            case 1?:
                realMonth = "January"
            case 2?:
                realMonth = "February"
            case 3?:
                realMonth = "March"
            case 4?:
                realMonth = "April"
            case 5?:
                realMonth = "May"
            case 6?:
                realMonth = "June"
            case 7?:
                realMonth = "July"
            case 8?:
                realMonth = "August"
            case 9?:
                realMonth = "September"
            case 10?:
                realMonth = "October"
            case 11?:
                realMonth = "November"
            case 12?:
                realMonth = "December"
            default:
                realMonth = "Error"
                
            }
            
            var tempHour = Int(post.hour)
            if self.userDefaults.bool(forKey: "is24HourTimeEnabled") {
                cell.openTimeLabel?.text = "\(post.hour):\(post.minutes)"
            }
            else
            {
                if(tempHour! > 12 && tempHour! != 24)
                {
                    tempHour! = tempHour! - 12
                    let tempLabelHour = "\(tempHour!)"
                    cell.openTimeLabel?.text = "\(tempLabelHour):\(post.minutes) PM"
                }
                else
                {
                    cell.openTimeLabel?.text = "\(post.hour):\(post.minutes) AM"
                }
            }
            
            cell.openMonthLabel?.text = realMonth
            cell.closedFullDateLabel?.text = "\(realMonth) \(post.day), \(post.year)"
            cell.closedBodyTextView?.text = post.body
            //            let urlCheck: String! = post.downloadURL
            if(String(post.downloadURL) != "")
            {
                let photoRef = self.storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(snap.key).jpg")
                print("photo ref is \(photoRef)\n\n")
                //                    let imageView: UIImageView = imageTableViewCell!.postImageView
                cell.openImageView!.sd_setImage(with: photoRef)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.self.imageTapped(tapGestureRecognizer:)))
                cell.openImageView!.addGestureRecognizer(tapGestureRecognizer)
            }
            
            return cell
        }
        dataSource?.bind(to: tableView)
        tableView.delegate = self
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
    
    override func viewWillAppear(_ animated: Bool) {
        
        setup()
//        self.tableView.reloadData()
        //        let presenceRef = Database.database().reference(withPath: "disconnectmessage");
        // Write a string when this client loses connection
        //        presenceRef.onDisconnectSetValue("I disconnected!")
        self.tabBarController?.tabBar.isHidden = false
        reloadFirebaseData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getQuery().removeAllObservers()
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
        let window = UIApplication.shared.keyWindow!
        newImageView.addGestureRecognizer(tap)
        window.addSubview(newImageView)
        newImageView.center = window.center
        newImageView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        newImageView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            newImageView.alpha = 1
            newImageView.transform = CGAffineTransform.identity
        }
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
        if self.userDefaults.bool(forKey: "isDarkModeEnabled"){
            bodyTextView.textColor = UIColor.white
            entryDate.textColor = UIColor.white
            addPostView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
            
        }
        else
        {
            bodyTextView.textColor = UIColor.black
        
            entryDate.textColor = UIColor.black
            addPostView.backgroundColor = UIColor.white
        }
        let window = UIApplication.shared.keyWindow!
        window.addSubview(addPostView)
        addPostView.center = window.center
        //        self.blurEffect.isUserInteractionEnabled = true
        
        addPostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        addPostView.alpha = 0
        
        UIView.animate(withDuration: 0.4) {
            //            self.blurEffect.effect = self.blur
            self.addPostView.alpha = 1
            self.addPostView.transform = CGAffineTransform.identity
        }
        
        self.tabBarController?.tabBar.isHidden = true
        self.view.isUserInteractionEnabled = false
        
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
        self.view.isUserInteractionEnabled = true
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
        self.navigationController?.isNavigationBarHidden = false
        self.tabBarController?.tabBar.isHidden = false
        let window = UIApplication.shared.keyWindow!
//        newImageView.addGestureRecognizer(tap)
//        window.addSubview(newImageView)
        UIView.animate(withDuration: 0.3, animations: {
            sender.view?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            sender.view?.alpha = 0
            
            //            self.blurEffect.effect = nil
            //            self.blurEffect.isUserInteractionEnabled = false
        }) { (success:Bool) in
            sender.view?.removeFromSuperview()
        }
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
//        reloadFirebaseData()
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
        let window = UIApplication.shared.keyWindow!
//        window.addSubview(addPostView)
//        addPostView.center = window.center
        window.endEditing(true)
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
    
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
    //
    func getQuery() -> DatabaseQuery {
        return (ref.child("users").child(getUid()))
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        if self.userDefaults.bool(forKey: "isDarkModeEnabled") {
            tableView.backgroundColor = UIColor.black
            navigationController?.navigationBar.barTintColor = UIColor.black
        }
        else
        {
            navigationController?.navigationBar.barTintColor = UIColor.white
            tableView.backgroundColor = UIColor(red:0.40, green:0.78, blue:0.73, alpha:1.0)
        }
    }
    
}

// MARK: - TableView
extension newFoldingPostListTableViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10000
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingTableViewCell = cell else {
            return
        }
        
        
//        dataSource = FUITableViewDataSource.init(query: (getQuery().queryOrdered(byChild: "timeStamp"))) { (tableView, indexPath, snap) -> UITableViewCell in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingTableViewCell
//            guard let post = Post.init(snapshot: snap) else { return cell }
//            cell.openBodyTextView?.text = post.body
//            //            cell.detailTextLabel?.text = post.body
//
//            return cell
//        }
        
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
//        cell.number = indexPath.row
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        let noDataLabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: tableView.bounds.size.width, height: tableView.bounds.size.height))
        noDataLabel.text = "No posts yet - why not add one?"
        noDataLabel.textColor = UIColor.black
        noDataLabel.textAlignment = .center
        tableView.backgroundView = noDataLabel
        tableView.separatorStyle = .none
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingTableViewCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let cell = tableView.cellForRow(at: indexPath) as! FoldingTableViewCell
        
        if cell.isAnimating() {
            return
        }
        
        var duration = 0.0
        let cellIsCollapsed = cellHeights[indexPath.row] == kCloseCellHeight
        if cellIsCollapsed {
            cellHeights[indexPath.row] = kOpenCellHeight
            cell.selectedAnimation(true, animated: true, completion: nil)
            duration = 0.5
        } else {
            cellHeights[indexPath.row] = kCloseCellHeight
            cell.selectedAnimation(false, animated: true, completion: nil)
            duration = 0.8
        }
        
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: { () -> Void in
            tableView.beginUpdates()
            tableView.endUpdates()
        }, completion: nil)
        
    }

}
