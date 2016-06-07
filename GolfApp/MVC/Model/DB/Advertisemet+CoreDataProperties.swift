//
//  Advertisemet+CoreDataProperties.swift
//  
//
//  Created by Admin on 06.06.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Advertisemet {

    @NSManaged var name: String?
    @NSManaged var url: String?
    @NSManaged var image: String?

}
