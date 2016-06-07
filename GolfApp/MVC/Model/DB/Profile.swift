//
//  Profile.swift
//  
//
//  Created by Admin on 06.06.16.
//
//

import Foundation
import CoreData


@objc(Profile)
class Profile: NSManagedObject {
    
    class func profileWhithDictionary(pDictionary:NSDictionary, andArray pArray: [String]) -> Profile {
        
        var lProfile : Profile!
        
        
//        if let oldProfile = Profile.MR_findByAttribute("id", withValue: NSNumber.init(long:pDictionary["id"] as! Int)).first as? Profile {
//            lProfile = oldProfile
//        } else {
//            lProfile = Profile.MR_createEntity() as! Profile
//        }
        
        lProfile = Profile.MR_createEntity() as! Profile
        
        lProfile.phone = pDictionary["phone"] as? String ?? ""
        lProfile.email = pDictionary["email"] as? String ?? ""
        lProfile.website = pDictionary["website"] as? String ?? ""
        lProfile.address = pDictionary["address"] as? String ?? ""
        lProfile.ios_url = pDictionary["ios_url"] as? String ?? ""
        lProfile.longitude = pDictionary["longitude"] as? String ?? ""
        lProfile.latitude = pDictionary["latitude"] as? String ?? ""
        lProfile.default_language = pDictionary["default_language"] as! Int
        lProfile.route = pDictionary["route"] as? String ?? ""
        lProfile.city = pDictionary["city"] as? String ?? ""
        lProfile.state = pDictionary["state"] as? String ?? ""
        lProfile.postalcode = pDictionary["postalcode"] as? String ?? ""
        lProfile.country = pDictionary["country"] as? String ?? ""
        lProfile.ios_status = pDictionary["ios_status"] as? String ?? ""
        lProfile.android_status = pDictionary["android_status"] as? String ?? ""
        lProfile.android_url = pDictionary["android_url"] as? String ?? ""
        lProfile.streetno = pDictionary["streetno"] as? String ?? ""
        lProfile.buttons = []
        
        for button in pArray {
            lProfile.buttons?.append(button)
        }
        
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        
        return lProfile
    }
    
}