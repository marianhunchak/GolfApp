//
//  Course.swift
//  GolfApp
//
//  Created by Admin on 6/8/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreData

@objc(Course)
class Course: NSManagedObject {

    class func courseWhithDictionary(pDictionary:NSDictionary) -> Course {
        
        let lCourse = Course.MR_createEntity() as! Course
        lCourse.id = pDictionary["id"] as! Int
        lCourse.name = pDictionary["name"] as! String
        lCourse.descr = pDictionary["descr"] as! String
        lCourse.holes = pDictionary["holes"] as! String
        lCourse.par = pDictionary["par"] as! String
        lCourse.length = pDictionary["length"] as! String
        lCourse.length_unit = (pDictionary["length_unit"] as! String) == "meter" ? "m" : "yd"
        lCourse.rate_count = pDictionary["rate_count"] as! Int
        lCourse.rate_url = pDictionary["rate_url"] as! String
        lCourse.facilities = pDictionary["facilities"] as! [String]
        lCourse.createdDate = NSDate()
        lCourse.images = []
        for imageDict in pDictionary["images"] as! NSArray {
            lCourse.images?.append(Image.imageWhithDictionary(imageDict as! NSDictionary))
        }
        return lCourse
    }

}
