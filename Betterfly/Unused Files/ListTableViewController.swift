////
////  ListTableViewController.swift
////  Betterfly
////
////  Created by Dominick Hera on 8/12/17.
////  Copyright © 2017 Dominick Hera. All rights reserved.
////
//
//
//import UIKit
////import CloudKit
//import Firebase
//import FirebaseDatabaseUI
//
//class ListTableViewController: UIViewController, UITableViewDelegate{
//
//
////        // [START define_database_reference]
////        var ref: DatabaseReference!
////        // [END define_database_reference]
////
////        var dataSource: FUITableViewDataSource?
////
////        @IBOutlet weak var tableView: UITableView!
////
////        override func viewDidLoad() {
////            super.viewDidLoad()
////
////            // [START create_database_reference]
////            ref = Database.database().reference()
////            // [END create_database_reference]
////
////            let identifier = "post"
////            let nib = UINib.init(nibName: "PostTableViewCell", bundle: nil)
////            tableView.register(nib, forCellReuseIdentifier: identifier)
////
////            dataSource = FUITableViewDataSource.init(query: getQuery()) { (tableView, indexPath, snap) -> UITableViewCell in
////                let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as! PostTableViewCell
////
////                guard let post = Post.init(snapshot: snap) else { return cell }
////                cell.authorImage.image = UIImage.init(named: "ic_account_circle")
////                cell.authorLabel.text = post.author
////                var imageName = "ic_star_border"
////                if (post.stars?[self.getUid()]) != nil {
////                    imageName = "ic_star"
////                }
////                cell.starButton.setImage(UIImage.init(named: imageName), for: .normal)
////                if let starCount = post.starCount {
////                    cell.numStarsLabel.text = "\(starCount)"
////                }
////                cell.postTitle.text = post.title
////                cell.postBody.text = post.body
////                return cell
////            }
////
////            dataSource?.bind(to: tableView)
////            tableView.delegate = self
////        }
////
////        override func viewWillAppear(_ animated: Bool) {
////            self.tableView.reloadData()
////        }
////
////        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
////            performSegue(withIdentifier: "detail", sender: indexPath)
////        }
////
////        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
////            return 150
////        }
////
////        func getUid() -> String {
////            return (Auth.auth().currentUser?.uid)!
////        }
////
////        func getQuery() -> DatabaseQuery {
////            return self.ref
////        }
////
////        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
////            guard let indexPath: IndexPath = sender as? IndexPath else { return }
////            guard let detail: PostDetailTableViewController = segue.destination as? PostDetailTableViewController else {
////                return
////            }
////            if let dataSource = dataSource {
////                detail.postKey = dataSource.snapshot(at: indexPath.row).key
////            }
////        }
////
////        override func viewWillDisappear(_ animated: Bool) {
////            getQuery().removeAllObservers()
////        }
////}
//
//
//    @IBOutlet weak var tableView: UITableView!
//
//    //    var data = ["About Me", "About the App","Contact Us","Social Media","Rate the App", "Share the App"]
//    //    var messages = [CKRecord]()
//    var refresh:UIRefreshControl!
////    var messageArray: Array<CKRecord> = []
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        tableView.delegate = self
////        tableView.dataSource = self
//
//        refresh = UIRefreshControl()
//        refresh.attributedTitle = NSAttributedString(string: "Pull to Refresh")
//        refresh.addTarget(self, action: #selector(ListTableViewController.loadData), for: UIControlEvents.valueChanged)
//        tableView.addSubview(refresh)
//        //        refresh.beginRefreshing()
//
//        loadData()
//    }
//
//    func loadData() {
//
////        messageArray = Array<CKRecord>()
//
////        let privateData = CKContainer.default().privateCloudDatabase
//        let sortPredicate = NSPredicate(value: true)
////        let query = CKQuery(recordType: "Message", predicate: sortPredicate)
//
//        query.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
//        privateData.perform(query, inZoneWith: nil) { (results, error) in
//            if error != nil {
//                print("Error" + error.debugDescription)
//            } else {
//                for results2 in results! {
////                    self.messageArray.append(results2)
//                }
//
//                OperationQueue.main.addOperation({ () -> Void in
//                    self.tableView.reloadData()
//                    self.tableView.isHidden = false
//                })
//            }
//
//        }
//
//    }
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
////        return messageArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "listCell", for: indexPath)
//        //        cell.textLabel?.text = data[indexPath.row]
////        let noteRecord: CKRecord = messageArray[(indexPath as IndexPath).row]
//
////        cell.textLabel?.text = noteRecord.value(forKey: "Status") as? String
//        //        cell.detailTextLabel?.text = noteRecord.value(forKey: "creationDate") as? String
//
//        cell.detailTextLabel?.text = "hi there"
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
//        //                cell.backgroundColor = UIColor.clear
//        cell.textLabel?.textColor = UIColor.white
//        cell.detailTextLabel?.textColor = UIColor.white
//        //                cell.textLabel?.font = UIFont(name: "SF UI Text", size:22)
//        cell.textLabel?.font = UIFont(name:"Avenir", size:30)
//        cell.detailTextLabel?.font = UIFont(name:"Avenir", size:20)
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        //        let selectedItem = data[indexPath.row]
////        let selectedItem = messageArray[indexPath.row]
//
//
//
//    }
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        //         Dispose of any resources that can be recreated.
//    }
//}
//
//
