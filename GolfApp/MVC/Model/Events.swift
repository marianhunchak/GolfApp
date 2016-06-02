//
//  Events.swift
//  GolfApp
//
//  Created by Admin on 20.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Events {
    
    var event_date : String!
    var name : String!
    var format : String!
    var remark1 : String!
    var remark2 : String!
    var file_detail : String!
    var file_teetime : String!
    var file_result : String!
    var file_default : String!
    var pubdate : String!
    
    static func eventWhithDictionary(pDictionary:NSDictionary) -> Events {
        
        let lEvents = Events()
        lEvents.event_date = pDictionary["event_date"] as? String ?? ""
        lEvents.name = pDictionary["name"] as? String ?? ""
        lEvents.format = pDictionary["format"] as? String ?? ""
        lEvents.remark1 = pDictionary["remark1"] as? String ?? ""
        lEvents.remark2 = pDictionary["remark2"] as? String ?? ""
        lEvents.file_detail = pDictionary["file_detail"] as? String ?? ""
        lEvents.file_teetime = pDictionary["file_teetime"] as? String ?? ""
        lEvents.file_result = pDictionary["file_result"] as? String ?? ""
        lEvents.file_default = pDictionary["file_default"] as? String ?? ""
        lEvents.pubdate = pDictionary["pubdate"] as? String ?? ""
        
        return lEvents
    }
    
}
