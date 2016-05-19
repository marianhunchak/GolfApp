//
//  Restaurant.swift
//  GolfApp
//
//  Created by Admin on 19.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreLocation

class Restaurant {
    
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
    var menu_url : String!
    var images = [Image]()
    var location: CLLocation?
    
    static func restaurantWhithDictionary(pDictionary:NSDictionary) -> Restaurant {
        
        let lRestaurant = Restaurant()
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
        
        for imageDict in pDictionary["images"] as! NSArray {
            lRestaurant.images += [Image.imageWhithDictionary(imageDict as! NSDictionary)]
        }
        
        return lRestaurant
    }
    
    
}