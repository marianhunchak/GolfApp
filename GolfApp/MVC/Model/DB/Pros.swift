//
//  Pros.swift
//  GolfApp
//
//  Created by Admin on 6/3/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreData

@objc(Pros)
class Pros: NSManagedObject {

    class func prosWhithDictionary(pDictionary:NSDictionary) -> Pros {
        
        var lPros : Pros!
        
        if let oldPros = Pros.MR_findByAttribute("id", withValue: NSNumber.init(long:pDictionary["id"] as! Int)).first as? Pros {
            lPros = oldPros
        } else {
            lPros = Pros.MR_createEntity() as! Pros
        }
        
        lPros.name = pDictionary["name"] as? String
        lPros.id = pDictionary["id"] as? Int
        lPros.descr = pDictionary["descr"] as? String
        lPros.phone = pDictionary["phone"] as? String
        lPros.email = pDictionary["email"] as? String
        lPros.website = pDictionary["website"] as? String
        lPros.address = pDictionary["address"] as? String
        lPros.city = pDictionary["city"] as? String
        lPros.country = pDictionary["country"] as? String
        lPros.longitude = pDictionary["longitude"] as? String
        lPros.latitude = pDictionary["latitude"] as? String
        lPros.package_count = pDictionary["package_count"] as? Int
        lPros.package_url = pDictionary["package_url"] as? String
        lPros.images = []
        
        for imageDict in pDictionary["images"] as! NSArray {
            lPros.images?.append(Image.imageWhithDictionary(imageDict as! NSDictionary))
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        return lPros
    }

}
