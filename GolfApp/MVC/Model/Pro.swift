//
//  Pro.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Pro {
    
    var tag: String?
    var client : String?
    var order : String?
    var total : Int?
    var pack = [PackageItem]()
    
    static func packageWhithDictionary(pDictionary:NSDictionary) -> Pro {
        
        let lPackage = Pro()
        lPackage.tag = pDictionary["tag"] as? String
        lPackage.client = pDictionary["client"] as? String
        lPackage.order = pDictionary["client"] as? String
        lPackage.total = pDictionary["client"] as? Int
        
        if let pakegArray = pDictionary["packages"] as? NSArray {
            for itemDict in pakegArray {
                lPackage.pack += [PackageItem.itemWhithDictionary(itemDict as! NSDictionary)]
            }
        }
        
        return lPackage
    }
    
}

struct PackageItem {
    
    var id : Int?
    var name : String?
    var subtitle : String?
    var descr : String?
    var pubdate : String?
    
    
    static func itemWhithDictionary(pDictionary:NSDictionary) -> PackageItem {
        
        var lItem = PackageItem()
        lItem.name = pDictionary["name"] as? String
        lItem.subtitle = pDictionary["subtitle"] as? String
        lItem.id = pDictionary["id"] as? Int
        lItem.descr = pDictionary["descr"] as? String
        lItem.pubdate = pDictionary["pubdate"] as? String
        
        return lItem
    }
    
}