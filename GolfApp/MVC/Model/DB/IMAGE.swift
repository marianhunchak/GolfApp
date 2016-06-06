//
//  IMAGE.swift
//  GolfApp
//
//  Created by Admin on 6/3/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreData

@objc(IMAGE)
class IMAGE: NSManagedObject {

    class func imageWhithName(pName: String, andPath pPath: NSURL) -> IMAGE {
        
        let lImage = IMAGE.MR_createEntity() as! IMAGE
        lImage.name = pName
        lImage.url = pPath
        
        return lImage
    }

}
