//
//  Profile+CoreDataProperties.swift
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

extension Profile {

    @NSManaged var phone: String?
    @NSManaged var email: String?
    @NSManaged var website: String?
    @NSManaged var address: String?
    @NSManaged var streetno: String?
    @NSManaged var route: String?
    @NSManaged var city: String?
    @NSManaged var state: String?
    @NSManaged var postalcode: String?
    @NSManaged var country: String?
    @NSManaged var longitude: String?
    @NSManaged var latitude: String?
    @NSManaged var ios_status: String?
    @NSManaged var android_status: String?
    @NSManaged var ios_url: String?
    @NSManaged var android_url: String?
    @NSManaged var default_language: NSNumber?
    @NSManaged var buttons: [String]?

}
