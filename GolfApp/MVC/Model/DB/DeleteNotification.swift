//
//  DeleteNotification.swift
//  
//
//  Created by Admin on 27.06.16.
//
//

import Foundation
import CoreData

@objc(Notification)
class DeleteNotification: NSManagedObject {
    
    class func notificationWithDictionary(pDict : [String : AnyObject]) -> DeleteNotification {
        
        let lDeleteNotification = DeleteNotification.MR_createEntity() as! DeleteNotification
        
        
        lDeleteNotification.post_id = pDict["post_id"] as! Int
        lDeleteNotification.sid = pDict["sid"] as! Int
        
        return lDeleteNotification
    }
    
}
