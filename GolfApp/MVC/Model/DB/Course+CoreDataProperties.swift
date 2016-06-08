//
//  Course+CoreDataProperties.swift
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

extension Course {

    @NSManaged var name: String!
    @NSManaged var id: NSNumber!
    @NSManaged var descr: String!
    @NSManaged var par: String!
    @NSManaged var holes: String!
    @NSManaged var length: String!
    @NSManaged var length_unit: String!
    @NSManaged var rate_url: String!
    @NSManaged var rate_count: NSNumber!
    @NSManaged var facilities: [String]!
    @NSManaged var images: [Image]!
    @NSManaged var createdDate: NSDate!

}
