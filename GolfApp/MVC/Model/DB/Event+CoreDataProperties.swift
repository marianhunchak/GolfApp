//
//  Event+CoreDataProperties.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/30/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Event {

    @NSManaged var id: NSNumber!
    @NSManaged var name: String!
    @NSManaged var event_date: String!
    @NSManaged var format: String!
    @NSManaged var remark1: String!
    @NSManaged var remark2: String!
    @NSManaged var file_detail: String!
    @NSManaged var file_teetime: String!
    @NSManaged var file_result: String!
    @NSManaged var file_default: String!
    @NSManaged var pubdate: String!
    @NSManaged var category: String!

}
