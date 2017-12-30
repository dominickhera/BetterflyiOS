//
//  PhotosTableViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 12/27/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabaseUI
import FirebaseStorageUI
import Photos
import SCLAlertView
import CircleMenu
import Crashlytics

class PhotosTableViewController: UITableViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    var storageRef: StorageReference!
    var camCheck = false
    var ref: DatabaseReference!
    var dataSource: FUITableViewDataSource?
    let userDefaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ref = Database.database().reference()
        ref.keepSynced(true)
        self.tabBarController?.tabBar.isHidden = false
        storageRef = Storage.storage().reference()
        self.tableView.separatorColor = UIColor.clear
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
        dataSource = FUITableViewDataSource.init(query: (getQuery().queryLimited(toLast: 10000))) { (tableView, indexPath, snap) -> UITableViewCell in
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoCell", for: indexPath) as! PhotosTableViewCell
            guard let post = Post.init(snapshot: snap) else { return cell }
            if(String(post.downloadURL) != "")
            {
                let photoRef = self.storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(snap.key).jpg")
                print("photo ref is \(photoRef)\n\n")
                //                    let imageView: UIImageView = imageTableViewCell!.postImageView
                cell.photoCellImageView!.sd_setImage(with: photoRef)
                let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.self.imageTapped(tapGestureRecognizer:)))
                cell.photoCellImageView!.addGestureRecognizer(tapGestureRecognizer)
                
//                cell.photoCellImageView!.addBlackGradientLayer(frame: cell.bounds, colors:[.clear, .black])
                self.camCheck = true
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
                
                cell.photoCellDateLabel?.text = "\(realMonth) \(post.day), \(post.year)"
                cell.photoCellTextBodyView?.text = post.body
                cell.photoCellTextBodyView?.layer.shadowRadius = 5.0
                cell.photoCellTextBodyView?.layer.shadowColor = UIColor.black.cgColor
                cell.photoCellTextBodyView?.layer.shadowOffset = CGSize(width: 4.0, height: 4.0)
                cell.photoCellTextBodyView?.layer.shadowOpacity = 1.0
                
                    
                
                cell.delegate = self
                
                
//                print("fuck")
            }
            else
            {
//                print("butthole")
                self.camCheck = false
////                cell.
//                cell.photoCellImageView.image = nil
//                cell.photoCellImageView.isHidden = true
//                cell.isHidden = true
            }
//
            return cell
        }
        
        dataSource?.bind(to: tableView)
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if self.userDefaults.bool(forKey: "isDarkModeEnabled") {
            tableView.backgroundColor = UIColor.black
            navigationController?.navigationBar.barTintColor = UIColor.black
        }
        else
        {
            navigationController?.navigationBar.barTintColor = UIColor.white
            tableView.backgroundColor = UIColor(red:0.18, green:0.81, blue:0.92, alpha:1.0)
        }
//        self.tableView.reloadData()
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
        return 10000
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
        let imageToShare =  cell.photoCellImageView.image!
        let textToShare = "\(String(describing: cell.photoCellDateLabel.text!)): \(cell.photoCellTextBodyView.text!)"
        let shareItems = [imageToShare, textToShare] as [Any]
        
//        let textImage = textToImage(drawText: cell.photoCellTextBodyView.text! as NSString, inImage: cell.photoCellImageView.image!, atPoint: CGPoint.zero)
//        let shareImage = [textImage]
        let activityViewController = UIActivityViewController(activityItems: shareItems , applicationActivities: nil)
                self.present(activityViewController, animated: true, completion: nil)
    
    }
}

//extension CGRect {
//    init(_ x:CGFloat, _ y:CGFloat, _ w:CGFloat, _ h:CGFloat) {
//        self.init(x:x, y:y, width:w, height:h)
//    }
//}

