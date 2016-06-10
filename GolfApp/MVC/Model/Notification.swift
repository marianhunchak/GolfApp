//
//  Notification.swift
//  GolfApp
//
//  Created by Admin on 6/10/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation


class Notification {
    
//    var language_id : Int!
    var post_id : Int!
    var post_type : String!
    var sid : Int!
    var sname : String!
    
    
    class func notificationWithDictionary(pDict : [String : AnyObject]) -> Notification {
        
        let lNotification = Notification()
        
//        lNotification.language_id = pDict["language_id"] as! Int
        lNotification.post_id = pDict["post_id"] as! Int
        lNotification.post_type = (pDict["post_type"] as! String).lowercaseString
        if lNotification.post_type == "pro" {
            lNotification.post_type = lNotification.post_type.stringByAppendingString("s")
        }
        lNotification.sid = pDict["sid"] as! Int
        lNotification.sname = pDict["sname"] as! String
        
        return lNotification
    }
}