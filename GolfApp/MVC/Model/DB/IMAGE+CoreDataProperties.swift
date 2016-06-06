//
//  IMAGE+CoreDataProperties.swift
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

extension IMAGE {

    @NSManaged var name: String?
    @NSManaged var url: NSURL?

}
