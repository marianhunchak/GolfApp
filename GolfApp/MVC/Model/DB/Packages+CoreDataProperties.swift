//
//  Packages+CoreDataProperties.swift
//  GolfApp
//
//  Created by Admin on 6/3/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Packages {

    @NSManaged var id: NSNumber?
    @NSManaged var name: String?
    @NSManaged var subtitle: String?
    @NSManaged var descr: String?
    @NSManaged var pubdate: String?
    @NSManaged var pros: Pros?

}
