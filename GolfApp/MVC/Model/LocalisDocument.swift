//
//  XMLParser.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/12/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import AEXML

class LocalisationDocument {
    
    static let sharedInstance = LocalisationDocument()
    var xmlDOC:AEXMLDocument?
    
    init() {
        
        let fileName = "string_" + Global.languageName
        let xmlPath = NSBundle.mainBundle().pathForResource(fileName, ofType: "xml")
        let data = NSData(contentsOfFile: xmlPath!)
        
        do {
            xmlDOC = try AEXMLDocument(xmlData: data!)
            
        }
            
        catch {
            print("\(error)")
        }
        
    }
    
    func getStringWhinName( pName : String) -> String {
        
        var returningString = ""
        
        if let titles = xmlDOC?.root["string"].allWithAttributes(["name" : pName]) {
            print(titles.first?.stringValue)
            returningString = (titles.first?.stringValue)!
        }
        
        return returningString
    }
}
