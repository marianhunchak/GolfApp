//
//  Item.swift
//  GolfApp
//
//  Created by Admin on 6/7/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Item : NSObject, NSCoding {
    
    var descr : String!
    var price : String!
    var id : NSNumber!
    var position : NSNumber!
    
    // MARK: Types
    struct PropertyKey {
        static let descrKey = "descr"
        static let priceKey = "price"
        static let idKey = "id"
        static let positionKey = "position"
    }
    
    init?(descr : String, price: String, id: Int, position: Int) {
        self.descr = descr
        self.price = price
        self.id = id
        self.position = position
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let descr = aDecoder.decodeObjectForKey(PropertyKey.descrKey) as! String
        let price = aDecoder.decodeObjectForKey(PropertyKey.priceKey) as! String
        let id = aDecoder.decodeObjectForKey(PropertyKey.idKey) as! Int
        let position = aDecoder.decodeObjectForKey(PropertyKey.positionKey) as! Int
        
        self.init(descr : descr, price: price, id: id, position: position)
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(descr, forKey: PropertyKey.descrKey)
        aCoder.encodeObject(price, forKey: PropertyKey.priceKey)
        aCoder.encodeObject(id, forKey: PropertyKey.idKey)
        aCoder.encodeObject(position, forKey: PropertyKey.positionKey)
    }
    
    class func itemWhithDictionary(pDictionary:NSDictionary) -> Item {
        
        let descr = pDictionary["descr"] as! String
        let price = pDictionary["price"] as! String
        let id = pDictionary["id"] as! Int
        let position = pDictionary["position"] as! Int
        
        return Item(descr: descr, price: price, id: id, position: position)!
    }
    
}