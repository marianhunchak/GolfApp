//
//  Hotel.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/17/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreLocation

class Hotel {
    
    var id : Int?
    var name : String!
    var descr : String!
    var phone : String!
    var email : String!
    var website : String!
    var address : String!
    var city : String!
    var country : String!
    var longitude : String!
    var latitude : String!
    var package_count : Int!
    var package_url : String!
    var images = [Image]()
    var location: CLLocation?
    
    static func hotelsWhithDictionary(pDictionary:NSDictionary) -> Hotel {
        
        let lHotel = Hotel()
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
        lHotel.package_count = pDictionary["package_count"] as? Int
        lHotel.package_url = pDictionary["package_url"] as? String ?? ""
        
        for imageDict in pDictionary["images"] as! NSArray {
            lHotel.images += [Image.imageWhithDictionary(imageDict as! NSDictionary)]
        }
        
        return lHotel
    }

    
}
