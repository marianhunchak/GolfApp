//
//  DeleteNotification.swift
//  
//
//  Created by Admin on 27.06.16.
//
//

import Foundation
import CoreData


import Foundation
import CoreData

@objc(DeleteNotification)
class DeleteNotification: NSManagedObject {
    
    class func notificationWithDictionary(pDict : [String : AnyObject]) -> DeleteNotification {
        
        let lDeleteNotification = DeleteNotification.MR_createEntity() as! DeleteNotification
        
        
        lDeleteNotification.postid = pDict["post_id"] as! Int
        lDeleteNotification.s_id = pDict["sid"] as! Int
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        return lDeleteNotification
    }
    
}
