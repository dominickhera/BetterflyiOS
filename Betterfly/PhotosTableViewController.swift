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
    var ref: DatabaseReference!
//    var dataSource: FUITableViewDataSource?
    let userDefaults = UserDefaults.standard
//    var postArray: Array<DataSnapshot> = []
//    var postArray: Array<DataSnapshot> = newFoldingPostListTableViewController.postArr
    let timeStamp = "\(Date().timeIntervalSince1970)"
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.keepSynced(true)
        self.tabBarController?.tabBar.isHidden = false
        storageRef = Storage.storage().reference()
        self.tableView.separatorColor = UIColor.clear
//        let timeStamp = "\(Date().timeIntervalSince1970)"
//        postArray.removeAll()
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
            globalVariables.postArray.insert(snapshot, at: 0)
            //            guard let post = Post.init(snapshot: snapshot) else { return }
            //            print("test: \(post.body)")
            //            self.tableView.beginUpdates()
            self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            //            self.tableView.endUpdates()
        })
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
        cell.delegate = self
        let postDict = globalVariables.postArray[(indexPath as NSIndexPath).row].value as? [String : AnyObject]
        
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
                    
                    ImageDownloader.default.downloadImage(with: imageURL!, options: [], progressBlock: nil) {
                        (imageStore, error, url, data) in
                        if(imageStore != nil)
                        {
                            ImageCache.default.store(imageStore!, forKey: "\(globalVariables.postArray[(indexPath as NSIndexPath).row].key).jpg")
                        }
                        //                                    print("Downloaded Image: \(image)")
                    }
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
    func sharePressed(cell: PhotosTableViewCell) {
//        guard let index = tableView.indexPath(for: cell)?.row else { return }
//        print("\(cell.photoCellTextBodyView.text!)")
        
        let alertView = SCLAlertView()
        alertView.addButton("Delete Post") {
            
        }
        alertView.addButton("Edit Post") {
            
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

