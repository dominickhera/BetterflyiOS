//
//  Post.swift
//  Betterfly
//
//  Created by Dominick Hera on 8/15/17.
//  Copyright © 2017 Dominick Hera. All rights reserved.
//

import UIKit
import Firebase

class Post: NSObject {
    var uid: String
    var month: String
    var day: String
    var year: String
    var time: String
    var date: String
    var hour: String
    var minutes: String
    var timeStamp: String
    var reverseTimeStamp: AnyObject?
    var downloadURL: String
    var body: String
    var searchTags: String
    
    
    init(uid: String, month: String, day: String, year: String, time: String,date: String, hour: String, minutes: String, timeStamp: String, reverseTimeStamp: AnyObject?, downloadURL: String, body: String, searchTags: String) {
        self.uid = uid
        self.month = month
        self.day = day
        self.year = year
        self.time = time
        self.date = date
        self.hour = hour
        self.minutes = minutes
        self.timeStamp = timeStamp
        self.reverseTimeStamp = reverseTimeStamp
        self.downloadURL = downloadURL
        self.body = body
        self.searchTags = searchTags
    }
    
    init?(snapshot: DataSnapshot) {
        guard let dict = snapshot.value as? [String: String] else { return nil }
        guard let uid  = dict["uid"]  else { return nil }
        guard let month = dict["month"] else { return nil }
        guard let day = dict["day"] else { return nil }
        guard let year = dict["year"] else { return nil }
        guard let time = dict["time"] else { return nil }
        guard let date = dict["date"] else { return nil }
        guard let hour = dict["hour"] else { return nil }
        guard let minutes = dict["minutes"] else { return nil }
        guard let timeStamp = dict["timeStamp"] else { return nil }
        guard let reverseTimeStamp = dict["reverseTimeStamp"] else { return nil }
        guard let downloadURL = dict["downloadURL"] else { return nil}
        guard let body = dict["body"] else { return nil }
        guard let searchTags = dict["searchTags"] else { return nil }
        
        self.uid = uid
        self.month = month
        self.day = day
        self.year = year
        self.time = time
        self.date = date
        self.hour = hour
        self.minutes = minutes
        self.timeStamp = timeStamp
        self.reverseTimeStamp = reverseTimeStamp as AnyObject
        self.downloadURL = downloadURL
        self.body = body
        self.searchTags = searchTags
    }
    
    convenience override init() {
        self.init(uid: "",month:"", day: "", year: "", time: "",date: "", hour: "", minutes: "", timeStamp: "", reverseTimeStamp: "" as AnyObject, downloadURL: "", body:  "", searchTags: "")
    }
}

