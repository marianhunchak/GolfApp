//
//  Event.swift
//  GolfApp
//
//  Created by Admin on 6/8/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import CoreData

@objc(Event)
class Event: NSManagedObject {
    
    class func eventWithDict(pDict : [String: AnyObject], andEventType eventType: String) -> Event {
        
        var lEvent : Event!

//        if let oldEvent = Event.MR_findByAttribute("id", withValue: NSNumber.init(long:pDict["id"] as! Int)).first as? Event {
//            lEvent = oldEvent
//        } else {
            lEvent = Event.MR_createEntity() as! Event
            lEvent.createdDate = NSDate()
//        }
    
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
        lEvent.category = eventType
        
        return lEvent
    }
    
}