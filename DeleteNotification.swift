//
//  DeleteNotification.swift
//  
//
//  Created by Admin on 28.06.16.
//
//

import Foundation
import CoreData


import CoreData


import Foundation
import CoreData

@objc(DeleteNotification)
class DeleteNotification: NSManagedObject {
    
    class func notificationWithDictionary(pDict : [String : AnyObject]) -> DeleteNotification {
        
        let lDeleteNotification = DeleteNotification.MR_createEntity() as! DeleteNotification
        
        if let languageId = pDict["language_id"] as? Int {
            lDeleteNotification.language_id = languageId
        } else {
            lDeleteNotification.language_id = Int(Global.languageID)
        }
        
        
        lDeleteNotification.postid = pDict["post_id"] as! Int
        lDeleteNotification.s_id = pDict["s_id"] as! Int
        lNotification.post_type = (pDict["post_type"] as! String).lowercaseString
        if lNotification.post_type == "pro" {
            lNotification.post_type = lNotification.post_type.stringByAppendingString("s")
        }
        lDeleteNotification.sname = pDict["sname"] as! String
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        return lDeleteNotification
    }
    
}
