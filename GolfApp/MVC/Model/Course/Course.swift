//
//  Course.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation


class Course {
    
    var name: String!
    var description_: String!
    var holes: String!
    var par: String!
    var length: String!
    var length_unit: String!
    var facilities: NSArray!
    var images: NSArray!
    
    static func courseWhithDictionary(pDictionary:NSDictionary) -> Course {
        
        let lCourse = Course()
        lCourse.name = pDictionary["name"] as! String
        lCourse.description_ = pDictionary["descr"] as! String
        lCourse.holes = pDictionary["holes"] as! String
        lCourse.par = pDictionary["par"] as! String
        lCourse.length = pDictionary["length"] as! String
        lCourse.length_unit = pDictionary["length_unit"] as! String
        lCourse.facilities = pDictionary["facilities"] as! NSArray
        lCourse.images = pDictionary["images"] as! NSArray
        
        return lCourse
    }
    
}