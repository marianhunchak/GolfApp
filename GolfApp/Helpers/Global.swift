//
//  File.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/12/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import UIKit

class Global {
    
    static let appName = "Golf App ES"
    static let clientId = "22";
    static var languageID : String!
    static var languageName : String!
    
    static let navigationBarColor = UIColor.init(colorCode: "97BF0D")
    static let buttonOnColor = UIColor.init(colorCode: "97BF0D")
    static let buttonOffColor = UIColor.init(colorCode: "5E7B2A")
    static let menuBarBackgroundColor = UIColor.init(colorCode: "404040")
    static let menuBarStokeColor = UIColor.init(colorCode: "000000")
    static let descrTextBoxColor = UIColor.init(colorCode: "404040")
    static let viewsBackgroundColor = UIColor.init(colorCode: "C8DC95")
    
    static let displayWidth = (UIApplication.sharedApplication().keyWindow?.frame.size.width)!
    
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
            languageName = "spanish"
        case "it":
            languageID = "5"
            languageName = "italian"
        default:
            languageID = "1"
            languageName = "english"
        }
    }
    
}