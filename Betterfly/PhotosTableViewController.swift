//
//  PhotosTableViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/27/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import Kingfisher
import FirebaseStorageUI
import Photos
import SCLAlertView
import Crashlytics
import SimpleImageViewer
import Floaty
import Kingfisher

class PhotosTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
//    var newFoldingPostListTableViewController: UITableViewController = UITableViewController()
    var storageRef: StorageReference!
    var camCheck = false
    var dupeCheck = false
    var deleteImageCheck = false
    var ref: DatabaseReference!
//    var dataSource: FUITableViewDataSource?
    let userDefaults = UserDefaults.standard
//    var postArray: Array<DataSnapshot> = []
//    var postArray: Array<DataSnapshot> = newFoldingPostListTableViewController.postArr
    let timeStamp = "\(Date().timeIntervalSince1970)"
    var tempEditKey = ""
    var tempEditTag = 0
    
    
    
    @IBOutlet var editPostView: UIView!
    
    @IBOutlet weak var editPostTextBody: UITextView!
    
    
    @IBOutlet weak var editPostImageView: UIImageView!
    
    @IBOutlet weak var editPostDeleteImageButton: UIButton!
    @IBOutlet weak var editPostDateLabel: UILabel!
    
//    var tempEditTextBody = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        ref = Database.database().reference()
        ref.keepSynced(true)
        self.tabBarController?.tabBar.isHidden = false
        storageRef = Storage.storage().reference()
        self.tableView.separatorColor = UIColor.clear
        editPostView.layer.cornerRadius = 10
        editPostImageView.isUserInteractionEnabled = false
        editPostImageView.addGestureRecognizer(tapGestureRecognizer)
//        imagePostImageView.isUserInteractionEnabled = false
//        imagePostImageView.addGestureRecognizer(tapGestureRecognizer)
//        editPostView.isHidden = true
//        postImageView.layer.cornerRadius = 5
//        removeImagePost.isHidden = true
//        editPostImageView.isHidden = true
//        editPostImageView.layer.cornerRadius = 5
//        editPostDeleteImageButton.isHidden = true
//        let timeStamp = "\(Date().timeIntervalSince1970)"
        globalVariables.postArray.removeAll()
        getQuery().queryOrdered(byChild: "timeStamp").observe(.childAdded, with: {  (snapshot) -> Void in
            globalVariables.postArray.insert(snapshot, at: 0)
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
        })
        
        
        
//        let floaty = Floaty()
////        //        let fab = KCFloatingActionButton()
//        floaty.addItem("Add Image", icon: UIImage(named: "picture-4")!, handler: { item in
//////            self.promptStatusBox((Any).self)
//            floaty.close()
//        })
//        floaty.addItem("Refresh List", icon: UIImage(named: "repeat")!, handler: { item in
////
//            self.self.refreshList()
//            floaty.close()
//        })
//        floaty.addItem("Search", icon: UIImage(named: "search-2")!, handler: { item in
//            floaty.close()
//        })
////        floaty.paddingY = 100
//        floaty.paddingY = self.view.frame.height/6 - floaty.frame.height/2
////        floaty.buttonColor = UIColor(red:0.93, green:0.39, blue:0.29, alpha:1.0)
//        floaty.friendlyTap = false
//        floaty.sticky = true
//        self.view.addSubview(floaty)
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        dataSource = FUITableViewDataSource.init(query: (getQuery().queryOrdered(byChild: "reverseTimeStamp"))) { (tableView, indexPath, snap) -> UITableViewCell in
//            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotosTableViewCell
//            guard let post = Post.init(snapshot: snap) else { return cell }
//            if(String(post.downloadURL) != "")
//            {
//                let photoRef = self.storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(snap.key).jpg")
//                print("photo ref is \(photoRef)\n\n")
//                //                    let imageView: UIImageView = imageTableViewCell!.postImageView
//                cell.photoCellImageView!.sd_setImage(with: photoRef)
//                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.self.imageTapped(tapGestureRecognizer:)))
//                cell.photoCellImageView!.addGestureRecognizer(tapGestureRecognizer)
//
////                cell.photoCellImageView!.addBlackGradientLayer(frame: cell.bounds, colors:[.clear, .black])
//                self.camCheck = true
//                let month = Int(post.month)
//                var realMonth = "Month"
//
//                switch(month){
//                case 1?:
//                    realMonth = "January"
//                case 2?:
//                    realMonth = "February"
//                case 3?:
//                    realMonth = "March"
//                case 4?:
//                    realMonth = "April"
//                case 5?:
//                    realMonth = "May"
//                case 6?:
//                    realMonth = "June"
//                case 7?:
//                    realMonth = "July"
//                case 8?:
//                    realMonth = "August"
//                case 9?:
//                    realMonth = "September"
//                case 10?:
//                    realMonth = "October"
//                case 11?:
//                    realMonth = "November"
//                case 12?:
//                    realMonth = "December"
//                default:
//                    realMonth = "Error"
//
//                }
//
//                cell.photoCellDateLabel?.text = "\(realMonth) \(post.day), \(post.year)"
//                cell.photoCellTextBodyView?.text = post.body
//                cell.photoCellTextBodyView?.layer.shadowRadius = 5.0
//                cell.photoCellTextBodyView?.layer.shadowColor = UIColor.black.cgColor
//                cell.photoCellTextBodyView?.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
//                cell.photoCellTextBodyView?.layer.shadowOpacity = 1.0
//
//
//
//                cell.delegate = self
//
//
////                print("fuck")
//            }
//            else
//            {
////                print("butthole")
//                self.camCheck = false
//////                cell.
////                cell.photoCellImageView.image = nil
////                cell.photoCellImageView.isHidden = true
////                cell.isHidden = true
//            }
////
//            return cell
//        }
//
//        dataSource?.bind(to: tableView)
//        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        postArray.removeAll()
//        self.tableView.reloadData()
        if self.userDefaults.bool(forKey: "isDarkModeEnabled") {
            tableView.backgroundColor = UIColor.black
            navigationController?.navigationBar.barTintColor = UIColor.black
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        }
        else
        {
            navigationController?.navigationBar.barTintColor = UIColor.white
            tableView.backgroundColor = UIColor(red:0.18, green:0.81, blue:0.92, alpha:1.0)
            self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.black]
        }
        
        //        if(makingPost == false) {
//        getQuery().queryOrdered(byChild: "reverseTimeStamp").observe(.childAdded, with: {  (snapshot) -> Void in
//            self.postArray.append(snapshot)
//            //            guard let post = Post.init(snapshot: snapshot) else { return }
//            //            print("test: \(post.body)")
//            //            self.tableView.beginUpdates()
//            self.tableView.insertRows(at: [IndexPath(row: self.postArray.count-1, section: 0)], with: .automatic)
//            //            self.tableView.endUpdates()
//        })
//        let timeStamp = "\(Date().timeIntervalSince1970)"
        getQuery().queryOrdered(byChild: "timeStamp").queryStarting(atValue: timeStamp).queryLimited(toLast: 1).observe(.childAdded, with: {  (snapshot) -> Void in
            //                self.tableView.beginUpdates()
            for postArray in globalVariables.postArray {
                if snapshot.key == postArray.key {
                    self.dupeCheck = true
                }
            }
            if(self.dupeCheck == false) {
//                globalVariables.postArray.insert(snapshot, at: 0)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
            //                self.tableView.endUpdates()
        })
//        self.tableView.reloadData()
        getQuery().queryOrdered(byChild: "timeStamp").observe(.childRemoved, with: { (snapshot) -> Void in
//            for postArray in self.postArray {
//                ImageCache.default.retrieveImage(forKey: "\(postArray.key).jpg", options: nil) {
//                    image, cacheType in
//                    if let image = image {
//                        print("cacheType: \(cacheType).")
//                        //In this code snippet, the `cacheType` is .disk
//                    } else {
//                        print("Not exist in cache.")
//                        let index = self.rowCountFunction(snapshot)
//                        self.postArray.remove(at: index)
//                        self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
//                    }
//                }
//            }
            let index = self.rowCountFunction(snapshot)
//            globalVariables.postArray.remove(at: index)
            self.tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: UITableViewRowAnimation.automatic)
//                self.tableView.reloadData()
        })
        self.tableView.reloadData()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        getQuery().removeAllObservers()
    }
    
    func rowCountFunction(_ snapshot: DataSnapshot) -> Int {
        var index = 0
        for postArray in globalVariables.postArray {
            if snapshot.key == postArray.key {
                return index
            }
            index += 1
        }
        return -1
    }
    
    
    func refreshList() {
        globalVariables.postArray.removeAll()
        self.tableView.reloadData()
        //        if(makingPost == false) {
        getQuery().observe(.childAdded, with: {  (snapshot) -> Void in
//            globalVariables.postArray.insert(snapshot, at: 0)
            //            guard let post = Post.init(snapshot: snapshot) else { return }
            //            print("test: \(post.body)")
            //            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            //            self.tableView.endUpdates()
        })
    }
    
    func blurInEdit() {
        //        self.makingPost = true
        if self.userDefaults.bool(forKey: "isDarkModeEnabled"){
            editPostTextBody.textColor = UIColor.white
            editPostDateLabel.textColor = UIColor.white
            editPostView.backgroundColor = UIColor(red:0.42, green:0.48, blue:0.54, alpha:1.0)
            
        }
        else
        {
            editPostTextBody.textColor = UIColor.black
            
            editPostDateLabel.textColor = UIColor.black
            editPostView.backgroundColor = UIColor.white
        }
        let window = UIApplication.shared.keyWindow!
        //        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.light)
        //        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        //        blurEffectView.frame = window.bounds
        //        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        //        window.addSubview(blurEffectView)
        window.addSubview(editPostView)
        editPostView.center = window.center
        //                self.blurEffect.isUserInteractionEnabled = true
        
        editPostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        editPostView.alpha = 0
        //        imagePostRemoveImage.isHidden = true
        UIView.animate(withDuration: 0.4) {
            //                        self.blurEffect.effect = self.blur
            self.editPostView.alpha = 1
            self.editPostView.transform = CGAffineTransform.identity
        }
        self.tableView.reloadData()
        self.tabBarController?.tabBar.isHidden = true
        self.view.isUserInteractionEnabled = false
//        editPostCheck = true
        
    }
    
    func blurOutEdit() {
        UIView.animate(withDuration: 0.3, animations: {
            self.editPostView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.editPostView.alpha = 0
            
            //                        self.blurEffect.effect = nil
            //                        self.blurEffect.isUserInteractionEnabled = false
        }) { (success:Bool) in
            //            for view in self.view.subviews {
            //                view.removeFromSuperview()
            //            }
            self.editPostView.removeFromSuperview()
            //            self.blurEffect.removeFromSuperview()
        }
        //        self.makingPost = false
//        editPostCheck = false
        self.tabBarController?.tabBar.isHidden = false
        self.view.isUserInteractionEnabled = true
        self.tableView.reloadData()
    }
    
    func imageTapped(tapGestureRecognizer: UITapGestureRecognizer)
    {
        //        let tappedImage = tapGestureRecognizer.view as! UIImageView
        let imageView = tapGestureRecognizer.view as! UIImageView
//        let newImageView = UIImageView(image: imageView.image)
        
        let configuration = ImageViewerConfiguration { config in
            config.imageView = imageView
        }
        
        present(ImageViewerController(configuration: configuration), animated: true)
        
//        let imageView = tapGestureRecognizer.view as! UIImageView
//        let newImageView = UIImageView(image: imageView.image)
        //                newImageView.frame = UIScreen.main.bounds
//        newImageView.backgroundColor = .black
//        newImageView.contentMode = .scaleAspectFit
//        newImageView.frame = UIScreen.main.bounds
//        newImageView.isUserInteractionEnabled = true
//        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
//        let window = UIApplication.shared.keyWindow!
//        newImageView.addGestureRecognizer(tap)
//        window.addSubview(newImageView)
//        newImageView.center = window.center
//        newImageView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
//        newImageView.alpha = 0
//
//        UIView.animate(withDuration: 0.4) {
//            newImageView.alpha = 1
//            newImageView.transform = CGAffineTransform.identity
//        }
//        self.navigationController?.isNavigationBarHidden = true
//        self.tabBarController?.tabBar.isHidden = true
        
        // Your action
    }
    
    
    
    
    @IBAction func didTapCancelEdit(_ sender: Any) {
        let window = UIApplication.shared.keyWindow!
        //        window.addSubview(addPostView)
        //        addPostView.center = window.center
        window.endEditing(true)
        if(self.editPostTextBody.text! != "" || self.editPostImageView.image != nil){
            let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
            let alert = SCLAlertView(appearance: appearance)
            _ = alert.addButton("Delete Edit")
            {
                self.editPostImageView.image = nil
                self.editPostImageView.isUserInteractionEnabled = false
                self.editPostImageView.isHidden = true
                self.blurOutEdit()
            }
            _ = alert.addButton("Cancel")
            {
                self.editPostTextBody.becomeFirstResponder()
                print("user canceled action.")
            }
            _ = alert.showWarning("Cancel current edit?", subTitle:"If you cancel now, you'll lose all the information you just edited.")
            
        }
        
        //        blurOut()
        print("user canceled status entry")
        
    }
    
    @IBAction func didTapUpdatePost(_ sender: Any) {
        let userID = Auth.auth().currentUser?.uid
        let key = tempEditKey
        let body = editPostTextBody.text
        let tag = tempEditTag
        let postDict = globalVariables.postArray[tag].value as? [String : AnyObject]
        //        let title = titleTextField.text
        //        let nsDate = NSDate()
        //        let postDate = ("\(nsDate)")
        //        let calendar = NSCalendar.current
        //        let year = calendar.component(.year, from: nsDate as Date)
        //        let month = calendar.component(.month, from: nsDate as Date)
        //        let day = calendar.component(.day, from: nsDate as Date)
        //        let hour = calendar.component(.hour, from: nsDate as Date)
        //        let minutes = calendar.component(.minute, from: nsDate as Date)
        let postHour = "\((postDict?["hour"])! as! String)"
        let postMinutes = "\((postDict?["minutes"])! as! String)"
        
        //        if (Int(postMinutes)! < 10)
        //        {
        //            postMinutes = "0\(minutes)"
        //        }
        
        //        let date = Date()
        //        let formatter = DateFormatter()
        
        //        formatter.locale = Locale(identifier: "en_US_POSIX")
        //        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
        //        formatter.timeZone = TimeZone(abbreviation: "UTC")
        //        let utcTimeZoneStr = formatter.string(from: date)
        //        let timestamp = (Date().timeIntervalSince1970 as NSString).doubleValue
        let timeStamp = "\((postDict?["timeStamp"])! as! String)"
        let doubleTimeStamp = Double(timeStamp)
        let reversedTimestamp = -1.0 * doubleTimeStamp!
        let realReverseTimeStamp = reversedTimestamp as AnyObject?
        //        let seconds = calendar.component(.second, from: date as Date)
        let postDate = ("\((postDict?["date"])! as! String)")
        let postMonth = ("\((postDict?["month"])! as! String)")
        let postDay = ("\((postDict?["day"])! as! String)")
        let postYear = ("\((postDict?["year"])! as! String)")
        let time = ("\((postDict?["time"])! as! String)")
        var downloadURL = "\((postDict?["downloadURL"])! as! String)"
        var searchTags = "\((postDict?["searchTags"])! as! String)"
        
        if editPostImageView.image != nil {
            if #available(iOS 11.0, *) {
                searchTags = "\(sceneLabel(forImage: (editPostImageView.image)!)!),\(sceneLabelTwo(forImage: (editPostImageView.image)!)!),\(sceneLabelThree(forImage: (editPostImageView.image)!)!)"
            }
            let image: UIImage = self.editPostImageView.image!
            ImageCache.default.store(image, forKey: "\(key).jpg")
            var data = Data()
            data = UIImageJPEGRepresentation(editPostImageView.image!, 0.2)!
            // set upload path
            ImageCache.default.store(self.editPostImageView.image!, forKey: "\(key).jpg")
            ImageCache.default.retrieveImage(forKey: "\(key).jpg", options: nil) {
                image, cacheType in
                if let image = image {
                    //                    print("Get image \(image), cacheType: \(cacheType).")
                    //In this code snippet, the `cacheType` is .disk
                    
                    let indexPath = IndexPath(row: tag, section: 0)
                    //                    if let path = self.expandedCellIndexPath, let expandedCell = self.tableView.cellForRow(at: path) as? FoldingTableViewCell {
                    //                        //                print("im done1")
                    ////                        expandedCell.unfold(false, animated: true, completion: nil)
                    //                        //                print("im done2")
                    ////                        self.cellHeights[path.row] = self.kCloseCellHeight
                    //                        //                print("im done3")
                    ////                        UIView.animate(withDuration: 0.8, delay: 0, options: .curveEaseOut, animations: { () -> Void in
                    //                            //                    print("im done4")
                    ////                            self.tableView.beginUpdates()
                    //                            //                    print("im done5")
                    ////                            self.tableView.endUpdates()
                    //                            //                    print("im done6")
                    //                        }, completion: nil)
                    //                print("im done7")
                    //                        self.expandedCellIndexPath = nil
                    //                print("im done8")
                    
                    
                    guard let cell = self.tableView.cellForRow(at: indexPath) as? PhotosTableViewCell else { return }
                    
                    cell.photoCellImageView.image! = image
                    
                    
                    
                } else {
                    print("Not exist in cache.")
                }
            }
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
                    //                    ImageCache.default.store(self.editPostImageView.image!, forKey: "\(key).jpg")
                    //                print("download url: \(downloadURL), photourl: \(photoURL)")
                    //                print("download url is now: \(downloadURL)")
                    //                    print("\(date)")
                    let post = ["uid": userID!,
                                "month": postMonth,
                                "day": postDay,
                                "year": postYear,
                                "time": time,
                                "date": postDate,
                                "hour": postHour,
                                "minutes": postMinutes,
                                "timeStamp": timeStamp,
                                "reverseTimeStamp": realReverseTimeStamp as Any,
                                "downloadURL": photoURL,
                                "body": body!,
                                "searchTags": searchTags]
                    
                    //                    print("\(userID!)")
                    let childUpdates = ["/users/\(userID!)/\(key)/": post]
                    self.ref.updateChildValues(childUpdates)
                    //store downloadURL at database
                }
            }
        }
        else{
            
            if deleteImageCheck == true {
                let imageRef = self.storageRef.child("users/").child(self.getUid()).child("/\(key).jpg")
                ImageCache.default.removeImage(forKey: "/\(key).jpg")
                
                // Delete the file
                imageRef.delete { error in
                    if error != nil {
                        // Uh-oh, an error occurred!
                    } else {
                        // File deleted successfully
                    }
                }
                downloadURL = ""
            }
            
            print("download url is now: \(downloadURL)")
            //            print("\(date)")
            let post = ["uid": userID!,
                        "month": postMonth,
                        "day": postDay,
                        "year": postYear,
                        "time": time,
                        "date": postDate,
                        "hour": postHour,
                        "minutes": postMinutes,
                        "timeStamp": timeStamp,
                        "reverseTimeStamp": realReverseTimeStamp as Any,
                        "downloadURL": downloadURL,
                        "body": body!,
                        "searchTags": searchTags]
            
            //            print("\(userID!)")
            let childUpdates = ["/users/\(userID!)/\(key)/": post]
            self.ref.updateChildValues(childUpdates)
            self.deleteImageCheck = false
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
        editPostImageView.image = nil
        editPostImageView.isUserInteractionEnabled = false
        editPostImageView.isHidden = true
        //        tempEditTag = 0
        //        tempEditKey = ""
        self.tableView.reloadData()
        refreshList()
        blurOutEdit()
    }
    
    @IBAction func didTapRemoveImageFromEdit(_ sender: Any) {
        self.view.endEditing(true)
        let appearance = SCLAlertView.SCLAppearance(showCloseButton: false)
        let alert = SCLAlertView(appearance: appearance)
        _ = alert.addButton("Delete Image")
        {
            self.editPostImageView.image = nil
            self.editPostImageView.isUserInteractionEnabled = false
            self.editPostImageView.isHidden = true
            self.editPostDeleteImageButton.isHidden = true
            self.deleteImageCheck = true
            //            self.blurOut()
        }
        _ = alert.addButton("Cancel")
        {
            self.editPostTextBody.becomeFirstResponder()
            print("user canceled action.")
        }
        _ = alert.showWarning("Delete attached Image?", subTitle:"Image will be deleted from the current post if you proceed.")
        
    }
    
    
    func sceneLabel (forImage image:UIImage) -> String? {
        if #available(iOS 11.0, *) {
            let mLModelOne = GoogLeNetPlaces()
            
            //        let imageData = image.jpeg(.medium)
            let resizedImage = image.resized(toWidth: 224)
            if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: (resizedImage?.cgImage)!) {
                guard let scene = try? mLModelOne.prediction(sceneImage: pixelBuffer) else {fatalError("Unexpected runtime error")}
                return scene.sceneLabel
                
            }
        } else {
            return nil
            // Fallback on earlier versions
        }
        
        return nil
    }
    
    func sceneLabelTwo (forImage image:UIImage) -> String? {
        if #available(iOS 11.0, *) {
            let mLModelTwo = SqueezeNet()
            let imageData = image.jpeg(.medium)
            let resizedImage = UIImage(data:imageData!,scale:1.0)?.resized(toWidth: 227)
            if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: (resizedImage?.cgImage)!) {
                guard let scene = try? mLModelTwo.prediction(image: pixelBuffer) else {fatalError("Unexpected runtime error")}
                return scene.classLabel
                
            }
        } else {
            return nil
            // Fallback on earlier versions
        }
        
        return nil
    }
    
    func sceneLabelThree (forImage image:UIImage) -> String? {
        if #available(iOS 11.0, *) {
            let mLModelThree = MobileNet()
            
            let imageData = image.jpeg(.medium)
            let resizedImage = UIImage(data:imageData!,scale:1.0)?.resized(toWidth: 224)
            if let pixelBuffer = ImageProcessor.pixelBuffer(forImage: (resizedImage?.cgImage)!) {
                guard let scene = try? mLModelThree.prediction(image: pixelBuffer) else {fatalError("Unexpected runtime error")}
                return scene.classLabel
                
            }
        } else {
            return nil
            // Fallback on earlier versions
        }
        
        return nil
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
//        sender.view?.removeFromSuperview()
    }
    
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
    //
    func getQuery() -> DatabaseQuery {
        return (ref.child("users").child(getUid()))
    }
    
    func textToImage(drawText text: NSString, inImage image: UIImage, atPoint point: CGPoint) -> UIImage {
        let textColor = UIColor.white
        let textFont = UIFont(name: "Helvetica Bold", size: 12)!
        
        let scale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(image.size, false, scale)
        
        let textFontAttributes = [
            NSFontAttributeName: textFont,
            NSForegroundColorAttributeName: textColor,
            ] as [String : Any]
        image.draw(in: CGRect(origin: CGPoint.zero, size: image.size))
        
        let rect = CGRect(origin: point, size: image.size)
        text.draw(in: rect, withAttributes: textFontAttributes)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return globalVariables.postArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotosTableViewCell
        cell.tag = indexPath.row
        cell.delegate = self
        let postDict = globalVariables.postArray[(indexPath as NSIndexPath).row].value as? [String : AnyObject]
//        cell.tag = indexPath.row
        if((postDict?["downloadURL"])! as! String  != "")
        {
//                        let photoRef = self.storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(postArray[(indexPath as NSIndexPath).row].key).jpg")
        //                print("photo ref is \(photoRef)\n\n")
        //                //                    let imageView: UIImageView = imageTableViewCell!.postImageView
//                        cell.photoCellImageView!.sd_setImage(with: photoRef)
            
            ImageCache.default.retrieveImage(forKey: "\(globalVariables.postArray[(indexPath as NSIndexPath).row].key).jpg", options: nil) {
                image, cacheType in
                if let image = image {
                    cell.photoCellImageView!.image = image
                    //                                print("Get image \(image), cacheType: \(cacheType).")
                    //In this code snippet, the `cacheType` is .dis
            
            
            
            
            
//            let imageURL = URL(string: (postDict?["downloadURL"])! as! String)
//            cell.photoCellImageView!.kf.indicatorType = .activity
//            cell.photoCellImageView!.kf.setImage(with: imageURL, options: [.onlyFromCache, .transition(.fade(0.2))])
            
                        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.self.imageTapped(tapGestureRecognizer:)))
                        cell.photoCellImageView!.addGestureRecognizer(tapGestureRecognizer)
        //
        ////                cell.photoCellImageView!.addBlackGradientLayer(frame: cell.bounds, colors:[.clear, .black])
                        self.camCheck = true
                        let month = Int((postDict?["month"] as? String)!)
                        var realMonth = "Month"
        //
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
        //
                        cell.photoCellDateLabel?.text = "\(realMonth) \((postDict?["day"])! as! String), \((postDict?["year"])! as! String)"
                        cell.photoCellTextBodyView?.text = postDict?["body"] as! String
                        cell.photoCellTextBodyView?.layer.shadowRadius = 5.0
                        cell.photoCellTextBodyView?.layer.shadowColor = UIColor.black.cgColor
                        cell.photoCellTextBodyView?.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
                        cell.photoCellTextBodyView?.layer.shadowOpacity = 1.0
                    
                } else {
                    let imageURL = URL(string: (postDict?["downloadURL"])! as! String)
                    cell.photoCellImageView!.kf.indicatorType = .activity
                    cell.photoCellImageView!.kf.setImage(with: imageURL, options: [.transition(.fade(0.2))])
                    
//                    ImageDownloader.default.downloadImage(with: imageURL!, options: [], progressBlock: nil) {
//                        (imageStore, error, url, data) in
//                        if(imageStore != nil)
//                        {
//                            ImageCache.default.store(imageStore!, forKey: "\(globalVariables.postArray[(indexPath as NSIndexPath).row].key).jpg")
//                        }
//                        //                                    print("Downloaded Image: \(image)")
//                    }
                    //                                ImageCache.default.store(cell.openImageView!.image!, forKey: "\(self.postArray[(indexPath as NSIndexPath).row].key).jpg")
                    //                                print("Not exist in cache.")
                }
            }
        //
        //
        //
        //                cell.delegate = self
        //
        //
        ////                print("fuck")
                    }
                    else
                    {
        ////                print("butthole")
                        self.camCheck = false
        //////                cell.
        ////                cell.photoCellImageView.image = nil
        ////                cell.photoCellImageView.isHidden = true
        ////                cell.isHidden = true
                    }
        
                    return cell
        
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotosTableViewCell
//
        if(self.camCheck == false)
        {
            return 0
        }
    
        return 450
    }

}

extension PhotosTableViewController: PhotoCellDelegate {
    func editPhotoCell(_ tag: Int) {
        let postKey = globalVariables.postArray[tag].key
        tempEditKey = postKey
        tempEditTag = tag
        print("this would edit the cell at row \(tempEditTag)")
        
//        let postKey = globalVariables.postArray[tag].key
//        tempEditKey = postKey
//        tempEditTag = tag
        print("postkey is \(postKey)")
        //        let post = self.postArray[tag].value
        let postDict = globalVariables.postArray[tag].value as? [String : AnyObject]
        //        let date = postDict?["date"] as? String
        //        let calendar = NSCalendar.current
        //        let year = postDict?["year"] as? String
        let month = postDict?["month"] as? String
        //        let day = postDict?["day"] as? String
        //        let hour = calendar.component(.hour, from: date as Date)
        //        let minutes = calendar.component(.minute, from: date as Date)
        var realMonth = "Month"
        
        switch(Int(month!)){
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
        
        //        if(hour < 12 || hour == 24) {
        //            entryDate.text = "\(realMonth) \(day), \(year) - \(hour):\(minutes) am"
        //        }
        //        else {
        //            entryDate.text = "\(realMonth) \(day), \(year) - \(hour):\(minutes) pm"
        //        }
        editPostDateLabel.text = "\(realMonth) \((postDict?["day"])! as! String), \((postDict?["year"])! as! String)"
        editPostTextBody.text = "\((postDict?["body"])! as! String)"
        
        if((postDict?["downloadURL"])! as! String  != "")
        {
            let photoRef = self.storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(globalVariables.postArray[tag].key).jpg")
            print("photo ref is \(photoRef)\n\n")
            editPostImageView.isUserInteractionEnabled = true
            editPostImageView.isHidden = false
            editPostDeleteImageButton.isHidden = false
            editPostImageView.contentMode = .scaleAspectFill
            let imageURL = URL(string: (postDict?["downloadURL"])! as! String)
            //            let photoUrl = URL((postDict?["downloadURL"])! as! String)
            //    //                    let imageView: UIImageView = imageTableViewCell!.postImageView
            //            editPostImageView!.sd_setImage(with: photoRef)
            editPostImageView.kf.indicatorType = .activity
            editPostImageView.kf.setImage(with: imageURL)
            //            let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.self.imageTapped(tapGestureRecognizer:)))
            //            cell.openImageView!.addGestureRecognizer(tapGestureRecognizer)
        }
        
        //        let tapPhotoGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapPhotoGestureRecognizer:)))
        //        postImageView.isUserInteractionEnabled = true
        //        postImageView.addGestureRecognizer(tapPhotoGestureRecognizer)
        blurInEdit()
        editPostTextBody.becomeFirstResponder()
//        print("buuts")
    }
    
    func deletePhotoCell(_ tag: Int) {
        let postKey = globalVariables.postArray[tag].key
        tempEditKey = postKey
        tempEditTag = tag
        print("this would delete the cell at row \(tempEditTag)")
    }
    
    func sharePressed(cell: PhotosTableViewCell) {
//        guard let index = tableView.indexPath(for: cell)?.row else { return }
//        print("\(cell.photoCellTextBodyView.text!)")
        
        let alertView = SCLAlertView()
        alertView.addButton("Delete Post") {
            self.deletePhotoCell(cell.tag)
        }
        alertView.addButton("Edit Post") {
            self.editPhotoCell(cell.tag)
        }
        alertView.addButton("Share Post") {
            let imageToShare =  cell.photoCellImageView.image!
            let textToShare = "\(String(describing: cell.photoCellDateLabel.text!)): \(cell.photoCellTextBodyView.text!)"
            let shareItems = [imageToShare, textToShare] as [Any]
            
            let activityViewController = UIActivityViewController(activityItems: shareItems , applicationActivities: nil)
            self.present(activityViewController, animated: true, completion: nil)
            
        }
        alertView.showEdit("Options", subTitle: "Select one of the options below.")
        
        
        
//
//        let imageToShare =  cell.photoCellImageView.image!
//        let textToShare = "\(String(describing: cell.photoCellDateLabel.text!)): \(cell.photoCellTextBodyView.text!)"
//        let shareItems = [imageToShare, textToShare] as [Any]
//
//        let textImage = textToImage(drawText: cell.photoCellTextBodyView.text! as NSString, inImage: cell.photoCellImageView.image!, atPoint: CGPoint.zero)
//        let shareImage = [textImage]
        
        
//        let activityViewController = UIActivityViewController(activityItems: shareItems , applicationActivities: nil)
//                self.present(activityViewController, animated: true, completion: nil)
    
    }
}

//extension CGRect {
//    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
//        self.init(x:x, y:y, width:w, height:h)
//    }
//}

