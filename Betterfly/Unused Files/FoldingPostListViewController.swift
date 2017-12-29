//
//  FoldingPostListViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/25/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import Photos
import SCLAlertView
import FoldingCell

class FoldingPostListViewController: UIViewController, UITableViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var storageRef: StorageReference!
    var camCheck = false
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    
    let kCloseCellHeight: CGFloat = 179
    let kOpenCellHeight: CGFloat = 488
    let kRowsCount = 10
    var cellHeights: [CGFloat] = []
    
    @IBOutlet weak var removeImagePost: UIButton!
    @IBOutlet var toolBarView: UIView!
    @IBOutlet var addPostView: UIView!
    @IBOutlet weak var bodyTextView: UITextView!
    @IBOutlet weak var entryDate: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
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
        reloadFirebaseData()
        
//        dataSource = FUITableViewDataSource.init(query: (getQuery().queryOrdered(byChild: "timeStamp"))) { (tableView, indexPath, snap) -> UITableViewCell in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
//            guard let post = Post.init(snapshot: snap) else { return cell }
//            cell.textLabel?.text = post.body
//            //            cell.detailTextLabel?.text = post.body
//
//            return cell
//        }
        
//        dataSource?.bind(to: tableView)
        tableView.delegate = self
        //        tableView.dataSource = self
        
        tableView.allowsMultipleSelectionDuringEditing = true
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        cellHeights = Array(repeating: kCloseCellHeight, count: kRowsCount)
        tableView.estimatedRowHeight = kCloseCellHeight
        tableView.rowHeight = UITableViewAutomaticDimension
//        tableView.backgroundColor = UIColor(patternImage: #imageLiteral(resourceName: "background"))
    }
    
    func reloadFirebaseData() {
        //        refresh.beginRefreshing()
        
//        dataSource = FUITableViewDataSource.init(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
//            guard let post = Post.init(snapshot: snap) else { return cell }
//            cell.textLabel?.text = post.body
//            //            cell.detailTextLabel?.text = post.body
//
//            return cell
//        }
        dataSource?.bind(to: tableView)
//                refresh.endRefreshing()
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
        
        
        self.tableView.reloadData()
        //        let presenceRef = Database.database().reference(withPath: "disconnectmessage");
        // Write a string when this client loses connection
        //        presenceRef.onDisconnectSetValue("I disconnected!")
        self.tabBarController?.tabBar.isHidden = false
//        reloadFirebaseData()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getQuery().removeAllObservers()
    }
    
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }

    func getQuery() -> DatabaseQuery {
        return (ref.child("users").child(getUid()))
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //AMOUNT OF POSTS . COUNT THING
        return 10
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard case let cell as FoldingTableViewCell = cell else {
            return
        }
        
        cell.backgroundColor = .clear
        
        if cellHeights[indexPath.row] == kCloseCellHeight {
            cell.selectedAnimation(false, animated: false, completion:nil)
        } else {
            cell.selectedAnimation(true, animated: false, completion: nil)
        }
        
        cell.number = indexPath.row
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "FoldingCell", for: indexPath) as! FoldingCell
        let durations: [TimeInterval] = [0.26, 0.2, 0.2]
        cell.durationsForExpandedState = durations
        cell.durationsForCollapsedState = durations
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath) as! FoldingCell
        
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
//        self.performSegue(withIdentifier: "detail", sender: indexPath)
        
    }
    
//    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
//        return true
//    }
//
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
    //    func tableView(tableView: UIImageView, canEditRowAt indexPath: IndexPath) -> Bool {
    //        return true
    //    }
    //
//    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
//        if (editingStyle == UITableViewCellEditingStyle.delete) {
//            print("butthole")
//            // handle delete (by removing the data from your array and updating the tableview)
//        }
//    }
    
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
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        guard let indexPath: IndexPath = sender as? IndexPath else { return }
//        guard let detail: PostInfoViewController = segue.destination as? PostInfoViewController else {
//            return
//        }
//        if let dataSource = dataSource {
//            detail.postKey = dataSource.snapshot(at: indexPath.row).key
//            print("postkey sending is \(detail.postKey)")
//        }
//    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

