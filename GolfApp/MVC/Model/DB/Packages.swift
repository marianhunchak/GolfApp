//
//  Packages.swift
//  GolfApp
//
//  Created by Admin on 6/3/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreData


class Packages: NSManagedObject {

    class func itemWhithDictionary(pDictionary:NSDictionary) -> Packages {
        
        var lPackage : Packages!
        
        if let oldPackages = Packages.MR_findByAttribute("id", withValue: NSNumber.init(long:pDictionary["id"] as! Int)).first as? Packages {
            lPackage = oldPackages
        } else {
            lPackage = Packages.MR_createEntity() as! Packages
        }
        
        lPackage.name = pDictionary["name"] as? String ?? ""
        lPackage.subtitle = pDictionary["subtitle"] as? String ?? ""
        lPackage.id = pDictionary["id"] as! Int
        lPackage.descr = pDictionary["descr"] as? String ?? ""
        lPackage.pubdate = pDictionary["pubdate"] as? String ?? ""
        
        return lPackage
    }

}
