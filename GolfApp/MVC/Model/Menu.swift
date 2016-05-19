//
//  Menu.swift
//  GolfApp
//
//  Created by Admin on 19.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Menu {
    
    var section: String!
    var position: Int!
    var items = [Item]()
    
    static func menuWhithDictionary(pDictionary:NSDictionary) -> Menu {
        
        let lMenu = Menu()
        lMenu.section = pDictionary["section"] as! String
        lMenu.position = pDictionary["position"] as! Int
        
        for itemDict in pDictionary["items"] as! NSArray {
            lMenu.items += [Item.itemWhithDictionary(itemDict as! NSDictionary)]
        }
        
        return lMenu
    }
    
}
