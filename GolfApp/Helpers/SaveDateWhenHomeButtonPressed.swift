//
//  SaveDateWhenHomeButtonPressed.swift
//  GolfApp
//
//  Created by Admin on 05.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation



class SaveDateWhenHomeButtonPressed{

    let defults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    func saveExitDate(notification : NSNotification) {
        let todaysDate : NSDate = NSDate()
        let dateformater : NSDateFormatter = NSDateFormatter()
        dateformater.dateFormat = "MM-dd-yyyy HH:mm"
        let dateInFormat : String = dateformater.stringFromDate(todaysDate)
        print(dateInFormat)
        
        
        defults.setObject(dateInFormat, forKey: "lastLoadDate")
        defults.synchronize()
    }
}
