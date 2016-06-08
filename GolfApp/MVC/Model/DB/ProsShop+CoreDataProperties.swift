//
//  ProsShop+CoreDataProperties.swift
//  
//
//  Created by Admin on 07.06.16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension ProsShop {

    @NSManaged var name: String?
    @NSManaged var descr: String?
    @NSManaged var phone: String?
    @NSManaged var email: String?
    @NSManaged var website: String?
    @NSManaged var address: String?
    @NSManaged var city: String?
    @NSManaged var country: String?
    @NSManaged var longitude: String?
    @NSManaged var latitude: String?
    @NSManaged var package_count: NSNumber?
    @NSManaged var package_url: String?
    @NSManaged var images: [Image]!
    @NSManaged var id: NSNumber?
    @NSManaged var packagesList: [Package]!
    @NSManaged var createdDate: NSDate?

}
