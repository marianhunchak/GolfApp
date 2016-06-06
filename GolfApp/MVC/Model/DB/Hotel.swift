//
//  Hotel.swift
//  GolfApp
//
//  Created by Admin on 6/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreData

@objc(Hotel)
class Hotel: NSManagedObject {

    class func hotelsWhithDictionary(pDictionary:NSDictionary) -> Hotel {
        
        var lHotel : Hotel!
        
        if let oldPackage = Hotel.MR_findByAttribute("id", withValue: NSNumber.init(long:pDictionary["id"] as! Int)).first as? Hotel {
            lHotel = oldPackage
        } else {
            lHotel = Hotel.MR_createEntity() as! Hotel
            lHotel.createdDate = NSDate()
        }
        lHotel.name = pDictionary["name"] as? String ?? ""
        lHotel.id = pDictionary["id"] as? Int
        lHotel.descr = pDictionary["descr"] as? String ?? ""
        lHotel.phone = pDictionary["phone"] as? String ?? ""
        lHotel.email = pDictionary["email"] as? String ?? ""
        lHotel.website = pDictionary["website"] as? String ?? ""
        lHotel.address = pDictionary["address"] as? String ?? ""
        lHotel.city = pDictionary["city"] as? String ?? ""
        lHotel.country = pDictionary["country"] as? String ?? ""
        lHotel.longitude = pDictionary["longitude"] as? String ?? ""
        lHotel.latitude = pDictionary["latitude"] as? String ?? ""
        lHotel.package_count = pDictionary["package_count"] as! Int
        lHotel.package_url = pDictionary["package_url"] as? String ?? ""
        if lHotel.packagesList != nil {
            lHotel.packagesList = []
        }
        lHotel.images = []
        
        for imageDict in pDictionary["images"] as! NSArray {
            lHotel.images?.append(Image.imageWhithDictionary(imageDict as! NSDictionary))
        }
        
        return lHotel
    }


}
