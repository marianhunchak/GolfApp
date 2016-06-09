//
//  RestaurantMenu+CoreDataProperties.swift
//  
//
//  Created by Admin on 09.06.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension RestaurantMenu {

    @NSManaged var menuId: NSNumber?
    @NSManaged var menuList: [Rate]!

}
