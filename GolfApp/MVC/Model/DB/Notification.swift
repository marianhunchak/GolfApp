//
//  Notification.swift
//  GolfApp
//
//  Created by Admin on 6/10/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreData

@objc(Notification)
class Notification: NSManagedObject {

    class func notificationWithDictionary(pDict : [String : AnyObject]) -> Notification {
        
        let lNotification = Notification.MR_createEntity() as! Notification
        
        if let languageId = pDict["language_id"] as? Int {
            lNotification.language_id = languageId
        } else {
            lNotification.language_id = Int(Global.languageID)
        }
        
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