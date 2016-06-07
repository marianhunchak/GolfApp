//
//  Rate.swift
//  GolfApp
//
//  Created by Admin on 15.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Rate : NSObject , NSCoding {
    
    var section: String!
    var position: NSNumber!
    var items : [Item] = [Item]()
    
    // MARK: Types
    struct PropertyKey {
        static let sectionKey = "section"
        static let positionKey = "position"
        static let itemsKey = "items"
    }
    
    init?(section : String, position: Int, items: [Item]) {
        self.section = section
        self.position = position
        self.items = items
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let section = aDecoder.decodeObjectForKey(PropertyKey.sectionKey) as! String
        let position = aDecoder.decodeObjectForKey(PropertyKey.positionKey) as! Int
        let items = aDecoder.decodeObjectForKey(PropertyKey.itemsKey) as! [Item]
        
        self.init(section : section, position: position, items: items)
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(section, forKey: PropertyKey.sectionKey)
        aCoder.encodeObject(position, forKey: PropertyKey.positionKey)
        aCoder.encodeObject(items, forKey: PropertyKey.itemsKey)
    }
    
    static func rateWhithDictionary(pDictionary:NSDictionary) -> Rate {

        let section = pDictionary["section"] as! String
        let position = pDictionary["position"] as! Int
        
        var lItems = [Item]()
        for itemDict in pDictionary["items"] as! NSArray {
            lItems += [Item.itemWhithDictionary(itemDict as! NSDictionary)]
        }
        
        return Rate(section : section, position: position, items: lItems)!
    }
}

