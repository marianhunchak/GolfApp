//
//  Notification+CoreDataProperties.swift
//  GolfApp
//
//  Created by Admin on 6/10/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Notification {

    @NSManaged var language_id: NSNumber!
    @NSManaged var post_type: String!
    @NSManaged var sid: NSNumber!
    @NSManaged var post_id: NSNumber!
    @NSManaged var sname: String!

}
