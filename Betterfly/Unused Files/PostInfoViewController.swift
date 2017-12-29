//
//  PostInfoViewController.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/15/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase
import FirebaseStorageUI
import FirebaseDatabaseUI
import ParallaxHeader

class imageTableViewCell: UITableViewCell {
//    var postKey: String?
//    var postRef: DatabaseReference!
//    var storageRef: StorageReference!
//    weak var headerImageView: UIView?
//    var PostInfoViewController: PostInfoViewController?
    
    @IBOutlet weak var postImageView: UIImageView!
    
    
//    func setupParallaxHeader()
//    {
//        let photoRef = storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(postKey!).jpg")
//        print("photo ref is \(photoRef)\n\n")
//        let imageView: UIImageView = postImageView
//        imageView.sd_setImage(with: photoRef)
//
//        //        imageWithGradient(img: imageView)
////        let view = UIView(frame: imageView.frame)
//        //        let gradient = CAGradientLayer()
//        //        gradient.frame = view.bounds
//        //        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//        //        gradient.locations = [0.0, 1]
//        //        view.layer.insertSublayer(gradient, at: 0)
////        imageView.addSubview(view)
////        imageView.bringSubview(toFront: view)
//        //            imageWithGradient(img: imageView)
////        headerImageView = imageView
//
////        PostInfoViewController?.tableView.parallaxHeader.view = imageView
////        PostInfoViewController?.tableView.parallaxHeader.height = 400
////        PostInfoViewController?.tableView.parallaxHeader.minimumHeight = 0
////        PostInfoViewController?.tableView.parallaxHeader.mode = .topFill
//        //        bodyTextField.showsVerticalScrollIndicator = true
//
//    }
}

class textBodyTableViewCell: UITableViewCell {
    
    @IBOutlet weak var bodyTextField: UITextView!
}

class PostInfoViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet var textOnlyEditToolBar: UIView!
    @IBOutlet var editToolBar: UIView!
//    @IBOutlet weak var bodyTextField: UITextView!
//    @IBOutlet weak var imageView: UIImageView!
    
//    @IBOutlet weak var editPostButton: UIBarButtonItem!
//    @IBOutlet weak var testBodyView: UIView!
//    @IBOutlet weak var nonImageDateLabel: UILabel!
//    @IBOutlet weak var imageDateLabel: UILabel!
    
    let imageNum = 0
    let dateNum = 1
    let textNum = 2
    
    var postKey = ""
//    var ref: DatabaseReference!
    let post: Post = Post()
    var imageDetect = ""
    lazy var ref: DatabaseReference = Database.database().reference()
    var postRef: DatabaseReference!
    var storageRef: StorageReference!
    var refHandle: DatabaseHandle?
    
    var imageTableViewCell: imageTableViewCell?
//    var dateTableViewCell: dateTableViewCell?
//    var textBodyTableViewCell: textBodyTableViewCell?
    weak var headerImageView: UIView?
//    var dataSource: FUITableViewDataSource?
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        self.tabBarController?.tabBar.isHidden = true
//        postRef = ref.child("users").child(getUid()).child(postKey)
        print("post key is \(postKey) <---\n\n")
        postRef = ref.child("users").child(getUid()).child(postKey)
//        print("hmm")
        
        
        storageRef = Storage.storage().reference()
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        
//        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped(tapGestureRecognizer:)))
//        postImageView.isHidden = true
//        postImageView.layer.cornerRadius = 5
        
//        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
//        let pageID: String! = self.restorationIdentifier
//        let urlCheck: String! = post.downloadURL
//        print(pageID)
        
        
//        if(urlCheck != "")
//        {
//            let photoRef = storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(postKey).jpg")
//            let imageView: UIImageView = self.imageView
//            set
            //imageTableViewCell?.postImageView.isUserInteractionEnabled = true
            //imageTableViewCell?.postImageView.addGestureRecognizer(tapGestureRecognizer)
            
            //setupParallaxHeader()
//            imageDetect = "image"
//
//            imageView.sd_setImage(with: photoRef)
//
//            let view = UIView(frame: imageView.frame)
//            let gradient = CAGradientLayer()
//            gradient.frame = view.frame
//            gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//            gradient.locations = [0.0, 1]
//            view.layer.insertSublayer(gradient, at: 0)
//            imageView.addSubview(view)
//            imageView.bringSubview(toFront: view)
            
//        }
        
        self.tableView.delegate = self
        self.tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
//        print("post key is bunz" + postKey)
//        let pageID2: String! = self.restorationIdentifier
        refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
            let postDict = snapshot.value as? [String: AnyObject] ?? [:]
            self.post.setValuesForKeys(postDict)
            self.tableView.reloadData()
//            self.navigationItem.title = self.post.time
//            print("body is \(self.post.body)\n\n")
            let urlCheck: String! = self.post.downloadURL
            print("url check is \(urlCheck!)")
            if(urlCheck != "")
            {
                self.imageDetect = "image"
//                self.setupParallaxHeader()
//                self.imageTableViewCell?.setupParallaxHeader()
            }
            print("image detect is now >\(self.imageDetect)<")

        })
    
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.isTranslucent = true
        self.tabBarController?.tabBar.isHidden = true
    }
    
    
    private func setupParallaxHeader()
    {
        print("post key is \(postKey)")
        let photoRef = storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(postKey).JPG")
        print("photo ref is \(photoRef)\n\n")
//        let imageView: UIImageView = imageTableViewCell!.postImageView
        imageTableViewCell?.postImageView.sd_setImage(with: photoRef)

//        imageWithGradient(img: imageView)

        let view = UIView(frame:  (imageTableViewCell?.frame)!)

//        let gradient = CAGradientLayer()
//        gradient.frame = view.bounds
//        gradient.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
//        gradient.locations = [0.0, 1]
//        view.layer.insertSublayer(gradient, at: 0)
         imageTableViewCell?.postImageView.addSubview(view)
         imageTableViewCell?.postImageView.bringSubview(toFront: view)
//            imageWithGradient(img: imageView)
        headerImageView =  imageTableViewCell?.postImageView

        tableView.parallaxHeader.view =  (imageTableViewCell?.postImageView)!
        tableView.parallaxHeader.height = 400
        tableView.parallaxHeader.minimumHeight = 0
        tableView.parallaxHeader.mode = .topFill
//        bodyTextField.showsVerticalScrollIndicator = true

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
        newImageView.center = self.view.center
        newImageView.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        newImageView.alpha = 0
        UIView.animate(withDuration: 0.4) {
            //            self.blurEffect.effect = self.blur
            newImageView.alpha = 1
            newImageView.transform = CGAffineTransform.identity
        }
        self.navigationController?.isNavigationBarHidden = true
        self.tabBarController?.tabBar.isHidden = true

        // Your action
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("yo fucker")
//        let cell: UITableViewCell
        
        switch (indexPath.row) {
        
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "dateTableViewCell")!
            
            refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
                let postDict = snapshot.value as? [String: AnyObject] ?? [:]
                self.post.setValuesForKeys(postDict)

                var realMonth = "Month"

                switch(self.post.month){
                case "1":
                    realMonth = "January"
                case "2":
                    realMonth = "February"
                case "3":
                    realMonth = "March"
                case "4":
                    realMonth = "April"
                case "5":
                    realMonth = "May"
                case "6":
                    realMonth = "June"
                case "7":
                    realMonth = "July"
                case "8":
                    realMonth = "August"
                case "9":
                    realMonth = "September"
                case "10":
                    realMonth = "October"
                case "11":
                    realMonth = "November"
                case "12":
                    realMonth = "December"
                default:
                    realMonth = "Error"
                }


                    var tempHour = Int(self.post.hour)
                    if(tempHour! > 12 && tempHour! != 24)
                    {
                        tempHour! = tempHour! - 12
                        let tempLabelHour = "\(tempHour!)"
                        cell.textLabel?.text = "\(realMonth) \(self.post.day), \(self.post.year) - \(tempLabelHour):\(self.post.minutes) PM"
                        print("\(realMonth) \(self.post.day), \(self.post.year) - \(tempLabelHour):\(self.post.minutes) PM")
                    }
                    else
                    {
                        cell.textLabel?.text = "\(realMonth) \(self.post.day), \(self.post.year) - \(self.post.hour):\(self.post.minutes) AM"
                        print("\(realMonth) \(self.post.day), \(self.post.year) - \(self.post.hour):\(self.post.minutes) AM")
                    }
            })
            return cell
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageTableViewCell") as! imageTableViewCell
            if imageDetect == "image" {
                storageRef = Storage.storage().reference()
//            cell.textLabel?.text = "image butthole"
//                setupParallaxHeader()
                let imageCell = cell as? imageTableViewCell
//                imageCell?.postKey = postKey
//                imageTableViewCell?.setupParallaxHeader()
//                let photoRef = storageRef.child("users/" + Auth.auth().currentUser!.uid + "/\(postKey).jpg")
////                imageCell?.postImageView.sd_setImage(with: photoRef)
//                print("photo ref is \(photoRef)\n\n")
//                let imageView: UIImageView = (imageCell?.postImageView)!
//////                imageCell?.postImageView.set
//                imageView.sd_setImage(with: photoRef)
////                tableView.reloadData()
//                let view = UIView(frame: imageView.frame)
//                imageView.addSubview(view)
//                imageView.bringSubview(toFront: view)
//
            }
            else
            {
                cell.postImageView.isHidden = true
                cell.postImageView.isUserInteractionEnabled = false
//                cell.textLabel?.text = ""
                cell.isHidden = true
            }
            return cell
        case 2:
            let cell = tableView.dequeueReusableCell(withIdentifier: "textBodyTableViewCell") as! textBodyTableViewCell
            cell.bodyTextField?.text = self.post.body
            
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "filler")!
            cell.isHidden = true
//            print("butthole sucks\n\n")
            
//            })
            //set the data here
            return cell
//        }
//        else {
//            let cell: UITableViewCell = UITableViewCell(style: UITableViewCellStyle.default, reuseIdentifier: "textBodyTableViewCell")
//
//            refHandle = postRef.observe(DataEventType.value, with: { (snapshot) in
//                let postDict = snapshot.value as? [String: AnyObject] ?? [:]
//                self.post.setValuesForKeys(postDict)
//                //            self.navigationItem.title = self.post.time
//                //            self.bodyTextField.text = self.post.body + "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
//                self.textBodyTableViewCell?.bodyTextField.text = self.post.body
//
////                if(self.imageDetect == "")
////                {
////                    self.textBodyTableViewCell?.bodyTextField.inputAccessoryView = self.textOnlyEditToolBar
////                }
////                else
////                {
//                    self.textBodyTableViewCell?.bodyTextField.inputAccessoryView = self.editToolBar
//                }

//            })

            //set the data here
//            return cell
        }
//        return cell
    }

    func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        //        self.navigationController?.isNavigationBarHidden = false
        //        self.tabBarController?.tabBar.isHidden = false
        sender.view?.removeFromSuperview()
        UIView.animate(withDuration: 0.3, animations: {
            sender.view?.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
           sender.view?.alpha = 0

            //            self.blurEffect.effect = nil
            //            self.blurEffect.isUserInteractionEnabled = false
        }) { (success:Bool) in
            sender.view?.removeFromSuperview()
//            newImageView.removeFromSuperview()
        }
        self.navigationController?.isNavigationBarHidden = false
    }
//
//    func imageWithGradient(img:UIImage!) -> UIImage {
//
//        UIGraphicsBeginImageContext(img.size)
//        let context = UIGraphicsGetCurrentContext()
//
//        img.draw(at: CGPoint(x: 0, y: 0))
//
//        let colorSpace = CGColorSpaceCreateDeviceRGB()
//        let locations:[CGFloat] = [0.0, 1.0]
//
//        let bottom = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5).cgColor
//        let top = UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor
//
//        let colors = [top, bottom] as CFArray
//
//        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors, locations: locations)
//
//        let startPoint = CGPoint(x: img.size.width/2, y: 0)
//        let endPoint = CGPoint(x: img.size.width/2, y: img.size.height)
//
//        context!.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: UInt32(0)))
//
//        let image = UIGraphicsGetImageFromCurrentImageContext()
//
//        UIGraphicsEndImageContext()
//
//        return image!
//    }
    
//    override func setEditing(_ editing: Bool, animated: Bool) {
//        super.setEditing(editing, animated: animated)
//        if(self.isEditing)
//        {
//                textBodyTableViewCell?.bodyTextField.isEditable = true
//                textBodyTableViewCell?.bodyTextField.becomeFirstResponder()
//        }
//        else
//        {
//            self.editButtonItem.title = "Edit"
//
//            let updatedBody = "\(textBodyTableViewCell!.bodyTextField.text!)"
//                    let updatePost = ["uid": post.uid,
//                                "month": post.month,
//                                "day": post.day,
//                                "year": post.year,
//                                "time": post.time,
//                                "date": post.date,
//                                "hour": post.hour,
//                                "minutes": post.minutes,
//                                "timeStamp": post.timeStamp,
//                                "reverseTimeStamp": post.reverseTimeStamp,
//                                "downloadURL": post.downloadURL,
//                                "body": updatedBody]
//
////                    print("\(userID!)")
//                    let childUpdates = ["/users/\(post.uid)/\(postKey)/": updatePost]
//                    self.ref.updateChildValues(childUpdates)
//            textBodyTableViewCell?.bodyTextField.isEditable = false
//        }
//    }

    
//    @IBAction func editPost(_ sender: Any) {
//        bodyTextField.isEditable = true
//        bodyTextField.becomeFirstResponder()
//    }
    func getUid() -> String {
        return (Auth.auth().currentUser?.uid)!
    }
    
 func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.row == 0 {
            if(imageDetect == "image")
            {
                return 300
            }
                else
            {
                return 0
            }
        }
        else if indexPath.row == 2
        {
            return 200
        }
        else if indexPath.row == 1
        {
            return 60
        }
        else
        {
            return 0
    }
}

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
