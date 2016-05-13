//
//  Profile.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/12/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Profile {
    
    var phone: String!
    var email: String!
    var website: String!
    var address: String!
    var iosUrl: String!
    var defaultLanguage: Int!
    var languages: NSDictionary!
    
    static func profileWhithDictionary(pDictionary:NSDictionary) -> Profile {
        
        let lProfile = Profile()
        lProfile.phone = pDictionary["phone"] as! String
        lProfile.email = pDictionary["email"] as! String
        lProfile.website = pDictionary["website"] as! String
        lProfile.address = pDictionary["address"] as! String
        lProfile.iosUrl = pDictionary["ios_url"] as! String
        lProfile.defaultLanguage = pDictionary["default_language"] as! Int
        lProfile.languages = pDictionary["languages"] as! NSDictionary
        
        return lProfile
    }
}