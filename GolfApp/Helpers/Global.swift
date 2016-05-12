//
//  File.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/12/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Global {
    
    static let appName = "Golf App ES"
    static let clientId = "22";
    static var languageID : String!
    static var languageName : String!
    
    static func getLanguage() {
        
        let lang = NSLocale.currentLocale().objectForKey(NSLocaleLanguageCode)! as! String
        
        switch lang {
        case "en":
            languageID = "1"
            languageName = "english"
        case "fr":
            languageID = "2"
            languageName = "french"
        case "de":
            languageID = "3"
            languageName = "german"
        case "es":
            languageID = "4"
            languageName = "italian"
        case "it":
            languageID = "5"
            languageName = "spanish"
        default:
            languageID = "1"
            languageName = "english"
        }
    }
    
}