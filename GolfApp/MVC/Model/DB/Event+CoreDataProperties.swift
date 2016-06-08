//
//  Event+CoreDataProperties.swift
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

extension Event {

    @NSManaged var category: String!
    @NSManaged var event_date: String!
    @NSManaged var file_default: String!
    @NSManaged var file_detail: String!
    @NSManaged var file_result: String!
    @NSManaged var file_teetime: String!
    @NSManaged var format: String!
    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var pubdate: String!
    @NSManaged var remark1: String!
    @NSManaged var remark2: String!
    @NSManaged var createdDate: NSDate!

}
