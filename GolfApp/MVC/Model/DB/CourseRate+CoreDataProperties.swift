//
//  CourseRate+CoreDataProperties.swift
//  GolfApp
//
//  Created by Admin on 6/8/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension CourseRate {

    @NSManaged var courseId: NSNumber!
    @NSManaged var ratesList: [Rate]!

}
