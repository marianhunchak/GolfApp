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
    
    static func menuWhithDictionary(pDictionary:NSDictionary) -> Menu {
        
        let lMenu = Menu()
        lMenu.section = pDictionary["section"] as! String
        lMenu.position = pDictionary["position"] as! Int
        
        
        return lMenu
    }
    
}
