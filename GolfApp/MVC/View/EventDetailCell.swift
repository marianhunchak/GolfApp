//
//  EventDetailCell.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/24/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import EventKit

class EventDetailCell: UITableViewCell {

    var event : Event!
    
    @IBOutlet weak var eventProgramBtn: UIButton!
    @IBOutlet weak var teeTimesBtn: UIButton!
    @IBOutlet weak var addToCalendarBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    @IBOutlet weak var bookAndShareLabel: UILabel!
    
    @IBAction func addToCalendarPressed(sender: UIButton) {
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let startDate = dateFormatter.dateFromString(event.event_date)
        
       addEventToCalendar(title: event.name, description: event.format, startDate: startDate!, endDate: startDate!)
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        eventProgramBtn.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("events_program_btn"), forState: .Normal)
        teeTimesBtn.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("events_tee_times_btn"), forState: .Normal)
        addToCalendarBtn.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("evt_addtodiary_btn"), forState: .Normal)
        phoneBtn.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("evt_phone_btn"), forState: .Normal)
        emailBtn.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("events_email_btn"), forState: .Normal)
        shareBtn.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("events_share_btn"), forState: .Normal)
        bookAndShareLabel.text = LocalisationDocument.sharedInstance.getStringWhinName("evt_book_share_title")
        
        contentView.backgroundColor = Global.viewsBackgroundColor
        
        addToCalendarBtn.backgroundColor = Global.buttonOnColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func addEventToCalendar(title title: String, description: String?, startDate: NSDate, endDate: NSDate, completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccessToEntityType(.Event, completion: { (granted, error) in
            if (granted) && (error == nil) {
                let event = EKEvent(eventStore: eventStore)
                event.title = title
                event.startDate = startDate
                event.endDate = endDate
                event.notes = description
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.saveEvent(event, span: .ThisEvent)
                } catch let e as NSError {
                    completion?(success: false, error: e)
                    return
                }
                completion?(success: true, error: nil)
            } else {
                completion?(success: false, error: error)
            }
        })
    }
    
}
