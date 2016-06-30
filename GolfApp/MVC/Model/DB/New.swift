//
//  New.swift
//  GolfApp
//
//  Created by Admin on 6/4/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreData

@objc(New)
class New: NSManagedObject {

    class func newsWhithDictionary(pDictionary:NSDictionary) -> New {
        
        
        
        var lNew : New!

        
        if let oldNew = New.MR_findByAttribute("id", withValue: NSNumber.init(long:pDictionary["id"] as! Int)).first as? New {
            
            lNew = oldNew
        } else {
            lNew = New.MR_createEntity() as! New
        }

        lNew.title = pDictionary["title"] as? String ?? ""
        lNew.subtitle = pDictionary["subtitle"] as? String ?? ""
        lNew.id = pDictionary["id"] as? Int
        lNew.descr = pDictionary["descr"] as? String ?? ""
        lNew.pubdate = pDictionary["pubdate"] as? String ?? ""
        lNew.updated_ = pDictionary["updated"] as? String ?? ""
        lNew.images = []
        
        for imageDict in pDictionary["images"] as! NSArray {
            lNew.images?.append(Image.imageWhithDictionary(imageDict as! NSDictionary))
        }

         NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
         print(New.MR_findAllSortedBy("updated_", ascending: false).count)
        return lNew
    }

}
