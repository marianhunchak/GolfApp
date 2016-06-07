//
//  ProsShop.swift
//  
//
//  Created by Admin on 07.06.16.
//
//

import Foundation
import CoreData

@objc(ProsShop)
class ProsShop: NSManagedObject {
    
    class func hotelsWhithDictionary(pDictionary:NSDictionary) -> ProsShop {
        
        var lProsShop : ProsShop!
        
        if let oldPackage = ProsShop.MR_findByAttribute("id", withValue: NSNumber.init(long:pDictionary["id"] as! Int)).first as? ProsShop {
            lProsShop = oldPackage
        } else {
            lProsShop = ProsShop.MR_createEntity() as! ProsShop
            lProsShop.createdDate = NSDate()
        }
        
        lProsShop.name = pDictionary["name"] as? String ?? ""
        lProsShop.id = pDictionary["id"] as? Int
        lProsShop.descr = pDictionary["descr"] as? String ?? ""
        lProsShop.phone = pDictionary["phone"] as? String ?? ""
        lProsShop.email = pDictionary["email"] as? String ?? ""
        lProsShop.website = pDictionary["website"] as? String ?? ""
        lProsShop.address = pDictionary["address"] as? String ?? ""
        lProsShop.city = pDictionary["city"] as? String ?? ""
        lProsShop.country = pDictionary["country"] as? String ?? ""
        lProsShop.longitude = pDictionary["longitude"] as? String ?? ""
        lProsShop.latitude = pDictionary["latitude"] as? String ?? ""
        lProsShop.package_count = pDictionary["package_count"] as? Int
        lProsShop.package_url = pDictionary["package_url"] as? String ?? ""
        if lProsShop.packagesList != nil {
            lProsShop.packagesList = []
        }
        
        lProsShop.images = []
        
        for imageDict in pDictionary["images"] as! NSArray {
            lProsShop.images?.append(Image.imageWhithDictionary(imageDict as! NSDictionary))
        }
        
        return lProsShop
    }
    
}
