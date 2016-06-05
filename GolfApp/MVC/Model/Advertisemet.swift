//
//  Advertisemet.swift
//  GolfApp
//
//  Created by Admin on 03.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Advertisemet {
    
    var name : String!
    var url : String!
    var image : String!

    
    static func advertisemetWhithDictionary(pDictionary:NSDictionary) -> Advertisemet {
        
        let lAdvertisemet = Advertisemet()
        lAdvertisemet.name = pDictionary["name"] as! String
        lAdvertisemet.url = pDictionary["url"] as! String
        lAdvertisemet.image = pDictionary["image"] as! String
  
        return lAdvertisemet
    }
}