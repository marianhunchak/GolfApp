//
//  Package.swift
//  GolfApp
//
//  Created by Admin on 6/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Package: NSObject, NSCoding {
    
    var id: NSNumber!
    var name: String!
    var subtitle: String!
    var descr: String!
    var pubdate: String!
    
    // MARK: Types
    struct PropertyKey {
        static let idKey = "id"
        static let nameKey = "name"
        static let subtitleKey = "subtitle"
        static let descrKey = "descr"
        static let pubdateKey = "pubdate"
    }
    
    init?(id: Int, name: String, subtitle: String, descr: String, pubdate: String) {
        self.id = id
        self.name = name
        self.subtitle = subtitle
        self.descr = descr
        self.pubdate = pubdate
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let id = aDecoder.decodeObjectForKey(PropertyKey.idKey) as! Int
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let subtitle = aDecoder.decodeObjectForKey(PropertyKey.subtitleKey) as! String
        let descr = aDecoder.decodeObjectForKey(PropertyKey.descrKey) as! String
        let pubdate = aDecoder.decodeObjectForKey(PropertyKey.pubdateKey) as! String
        
        self.init(id: id, name: name, subtitle: subtitle, descr: descr, pubdate: pubdate)
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(id, forKey: PropertyKey.idKey)
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(subtitle, forKey: PropertyKey.subtitleKey)
        aCoder.encodeObject(descr, forKey: PropertyKey.descrKey)
        aCoder.encodeObject(pubdate, forKey: PropertyKey.pubdateKey)
    }
    
    // MARK: Private methods
    
    static func packageWhithDictionary(pDictionary:NSDictionary) -> Package {
        
        let name = pDictionary["name"] as? String ?? ""
        let subtitle = pDictionary["subtitle"] as? String ?? ""
        let id = pDictionary["id"] as! Int
        let descr = pDictionary["descr"] as? String ?? ""
        let pubdate = pDictionary["pubdate"] as? String ?? ""
        
        return Package(id: id, name: name, subtitle: subtitle, descr: descr, pubdate: pubdate)!
    }
}