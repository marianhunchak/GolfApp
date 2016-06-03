//
//  Image.swift
//  GolfApp
//
//  Created by Admin on 6/3/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Image : NSObject,  NSCoding {
    
    // MARK: Properties
    var name : String!
    var url : String!
    
    // MARK: Types
    struct PropertyKey {
        static let nameKey = "name"
        static let urlKey = "url"
    }
    
    init?(name: String, url: String) {
        self.name = name
        self.url = url
        
        super.init()
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        let name = aDecoder.decodeObjectForKey(PropertyKey.nameKey) as! String
        let url = aDecoder.decodeObjectForKey(PropertyKey.urlKey) as! String
        
        self.init(name: name, url: url)
    }
    
    // MARK: NSCoding
    
    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(name, forKey: PropertyKey.nameKey)
        aCoder.encodeObject(url, forKey: PropertyKey.urlKey)
    }
    
    // MARK: Private methods
    
    static func imageWhithDictionary(pDictionary:NSDictionary) -> Image {
        
        let name = pDictionary["name"] as? String ?? ""
        let url = pDictionary["url"] as? String ?? ""
        
        return Image(name: name, url: url)!
    }
    
}