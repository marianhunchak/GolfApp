//
//  Pros.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Pros {
    
    var id : Int?
    var name : String?
    var descr : String?
    var phone : String?
    var email : String?
    var website : String?
    var address : String?
    var city : String?
    var country : String?
    var longitude : String?
    var latitude : String?
    var package_count : Int?
    var package_url : String?
    var image = [Image]()
    
    static func prosWhithDictionary(pDictionary:NSDictionary) -> Pros {
        
        let lPros = Pros()
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
        
        for imageDict in pDictionary["items"] as! NSArray {
            lPros.image += [Image.imageWhithDictionary(imageDict as! NSDictionary)]
        }
        
        return lPros
    }
    
}

struct Image {
    
    var name : String!
    var url : String!

    
    static func imageWhithDictionary(pDictionary:NSDictionary) -> Image {
        
        var lImage = Image()
        lImage.name = pDictionary["name"] as! String
        lImage.url = pDictionary["url"] as! String

        return lImage
    }
    
}
