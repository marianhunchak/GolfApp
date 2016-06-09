//
//  Restaurant.swift
//  
//
//  Created by Admin on 08.06.16.
//
//

import Foundation
import CoreData

@objc(Restaurant)
class Restaurant: NSManagedObject {

    class func restaurantWhithDictionary(pDictionary:NSDictionary) -> Restaurant {
        
        var lRestaurant : Restaurant!
        
        if let oldPackage = Restaurant.MR_findByAttribute("id", withValue: NSNumber.init(long:pDictionary["id"] as! Int)).first as? Restaurant {
            lRestaurant = oldPackage
        } else {
            lRestaurant = Restaurant.MR_createEntity() as! Restaurant
            lRestaurant.createdDate = NSDate()
        }

        lRestaurant.name = pDictionary["name"] as? String ?? ""
        lRestaurant.id = pDictionary["id"] as? Int
        lRestaurant.descr = pDictionary["descr"] as? String ?? ""
        lRestaurant.phone = pDictionary["phone"] as? String ?? ""
        lRestaurant.email = pDictionary["email"] as? String ?? ""
        lRestaurant.website = pDictionary["website"] as? String ?? ""
        lRestaurant.address = pDictionary["address"] as? String ?? ""
        lRestaurant.city = pDictionary["city"] as? String ?? ""
        lRestaurant.country = pDictionary["country"] as? String ?? ""
        lRestaurant.longitude = pDictionary["longitude"] as? String ?? ""
        lRestaurant.latitude = pDictionary["latitude"] as? String ?? ""
        lRestaurant.package_count = pDictionary["package_count"] as? Int
        lRestaurant.package_url = pDictionary["package_url"] as? String ?? ""
        lRestaurant.menu_url = pDictionary["menu_url"] as? String ?? ""
        
        if lRestaurant.packagesList == nil {
            lRestaurant.packagesList = []
        }

        lRestaurant.images = []
        
        for imageDict in pDictionary["images"] as! NSArray {
            lRestaurant.images?.append(Image.imageWhithDictionary(imageDict as! NSDictionary))
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        return lRestaurant
    }

}
