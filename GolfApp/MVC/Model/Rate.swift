//
//  Rate.swift
//  GolfApp
//
//  Created by Admin on 15.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Rate {
    
    var section: String!
    var position: Int!
    var items = [Item]()
    
    static func rateWhithDictionary(pDictionary:NSDictionary) -> Rate {
        
        let lRate = Rate()
        lRate.section = pDictionary["section"] as! String
        lRate.position = pDictionary["position"] as! Int
        
        for itemDict in pDictionary["items"] as! NSArray {
            lRate.items += [Item.itemWhithDictionary(itemDict as! NSDictionary)]
        }
        
        return lRate
    }
    
}

struct Item {
    
    var descr : String!
    var price : String!
    var id : Int!
    var position : Int!
    
    static func itemWhithDictionary(pDictionary:NSDictionary) -> Item {
        
        var lItem = Item()
        lItem.descr = pDictionary["descr"] as! String
        lItem.price = pDictionary["price"] as! String
        lItem.id = pDictionary["id"] as! Int
        lItem.position = pDictionary["position"] as! Int
        
        return lItem
    }
    
}