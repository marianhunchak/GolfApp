//
//  NotificationHandle.swift
//  GolfApp
//
//  Created by Admin on 24.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class NotificationHandle {
    
    var language_id: NSNumber!
    var post_type: String!
    var sid: NSNumber!
    var post_id: NSNumber!
    var sname: String!
    
    static func notificationHandleWhithDictionary(pDictionary:NSDictionary) -> NotificationHandle {
        
        let lNotificationHandle = NotificationHandle()

        if let languageId = pDictionary["language_id"] as? Int {
            lNotificationHandle.language_id = languageId
        } else {
            lNotificationHandle.language_id = Int(Global.languageID)
        }
        lNotificationHandle.post_id = pDictionary["post_id"] as? Int ?? Int("")
        
        lNotificationHandle.post_type = (pDictionary["post_type"] as? String ?? "").lowercaseString
        if lNotificationHandle.post_type == "pro" {
            lNotificationHandle.post_type = lNotificationHandle.post_type.stringByAppendingString("s")
        }
        
        lNotificationHandle.sid = pDictionary["sid"] as? Int ?? Int("")
        lNotificationHandle.sname = pDictionary["sname"] as? String ?? ""
        
        return lNotificationHandle
    }
    
}
