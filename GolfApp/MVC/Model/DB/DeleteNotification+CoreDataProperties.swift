//
//  DeleteNotification+CoreDataProperties.swift
//  
//
//  Created by Admin on 28.06.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension DeleteNotification {

    @NSManaged var post_id: NSNumber?
    @NSManaged var s_id: NSNumber?
    @NSManaged var language_id: NSNumber?
    @NSManaged var post_type: String?
    @NSManaged var sname: String?

}
