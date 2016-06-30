//
//  Advertisemet.swift
//  
//
//  Created by Admin on 06.06.16.
//
//

import Foundation
import CoreData

@objc(Advertisemet)
class Advertisemet: NSManagedObject {

    class func advertisemetWhithDictionary(pDictionary:NSDictionary) -> Advertisemet {
        
        Advertisemet.MR_truncateAll()
        

        let lAdvertisemet = Advertisemet.MR_createEntity() as! Advertisemet
        lAdvertisemet.name = pDictionary["name"] as? String ?? ""
        lAdvertisemet.url = pDictionary["url"] as? String ?? ""
        lAdvertisemet.image = pDictionary["image"] as? String ?? ""
        
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        return lAdvertisemet
    }

}
