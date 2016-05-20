//
//  Pro.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Package {


    var id : Int?
    var name : String!
    var subtitle : String!
    var descr : String!
    var pubdate : String!
    
    
    static func itemWhithDictionary(pDictionary:NSDictionary) -> Package {
        
        let lItem = Package()
        lItem.name = pDictionary["name"] as? String ?? ""
        lItem.subtitle = pDictionary["subtitle"] as? String ?? ""
        lItem.id = pDictionary["id"] as? Int
        lItem.descr = pDictionary["descr"] as? String ?? ""
        lItem.pubdate = pDictionary["pubdate"] as? String ?? ""
        
        return lItem
    }
    
}