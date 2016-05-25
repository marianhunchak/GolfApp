//
//  Event.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/23/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Event {
    
    var id : Int!
    var event_date : String!
    var name : String!
    var format : String!
    var remark1 : String!
    var remark2 : String!
    var file_detail : String!
    var file_teetime : String!
    var file_default : String!
    var file_result : String!
    var pubdate: String!
    
    class func eventWithDict(pDict : [String: AnyObject]) -> Event {
        let lEvent = Event()
        lEvent.id = pDict["id"] as! Int
        lEvent.event_date = pDict["event_date"] as? String ?? ""
        lEvent.name = pDict["name"] as? String ?? ""
        lEvent.format = pDict["format"] as? String ?? ""
        lEvent.remark1 = pDict["remark1"] as? String ?? ""
        lEvent.remark2 = pDict["remark2"] as? String ?? ""
        lEvent.file_detail = pDict["file_detail"] as? String ?? ""
        lEvent.file_teetime = pDict["file_teetime"] as? String ?? ""
        lEvent.file_default = pDict["file_default"] as? String ?? ""
        lEvent.file_result = pDict["file_result"] as? String ?? ""
        lEvent.pubdate = pDict["pubdate"] as? String ?? ""
        
        return lEvent
    }
    
}