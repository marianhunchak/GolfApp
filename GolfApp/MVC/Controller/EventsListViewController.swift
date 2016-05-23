//
//  EventsViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/23/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellImagereuseIdentifier = "detailImageTableCell"
private let NewsTableCellIndetifire = "NewsDetailCell"

class EventsListViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var viewForHeader: UIView!
    
    var eventsArray = [Event]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupHeaderView()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("evt_list_view_nav_bar")
        
        let nibFood = UINib.init(nibName: NewsTableCellIndetifire, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: NewsTableCellIndetifire)
        
        self.tableView.estimatedRowHeight = 80
        
        
        NetworkManager.sharedInstance.getEventsWithCategory("past") { (array) in
            
            if  array != nil {
                self.eventsArray = array!
                self.tableView.reloadData()
            }
        }
    }
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return eventsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsDetailCell", forIndexPath: indexPath) as! NewsDetailCell
        
        let event = eventsArray[indexPath.row]
        cell.nameLabel.text = event.name
        cell.subtitleLabel.text = event.format
       
        cell.descriptionNews.text = event.remark1 + "\n" + event.remark2

        cell.dateLabel.text = getDayOfWeek(event.event_date) + " " + event.event_date
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    //MARK: Private methods
    
    func setupHeaderView() {
        let lHeader = ViewForProHeader.loadViewFromNib()
        lHeader.frame = CGRectMake(0.0, 0.0, Global.displayWidth, viewForHeader.frame.size.height)
        self.viewForHeader.addSubview(lHeader)
        
        lHeader.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("evt_upcoming_event_btn"), forState: .Normal)
        lHeader.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("evt_pastevent_btn"), forState: .Normal)
        
        lHeader.setButtonEnabled(lHeader.button1, enabled: true)
        lHeader.setButtonEnabled(lHeader.button2, enabled: false)
        
        //        lHeader.delegate = self
    }
    
    func getDayOfWeek(today:String)->String {
        
        let formatter  = NSDateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let todayDate = formatter.dateFromString(today) {
            let myCalendar = NSCalendar(calendarIdentifier: NSCalendarIdentifierGregorian)!
            let myComponents = myCalendar.components(.Weekday, fromDate: todayDate)
            let weekDay = myComponents.weekday
            
            switch weekDay {
            case 1:
                return LocalisationDocument.sharedInstance.getStringWhinName("events_sunday")
            case 2:
                return LocalisationDocument.sharedInstance.getStringWhinName("events_monday")
            case 3:
                return LocalisationDocument.sharedInstance.getStringWhinName("events_tuesday")
            case 4:
                return LocalisationDocument.sharedInstance.getStringWhinName("events_wednesday")
            case 5:
                return LocalisationDocument.sharedInstance.getStringWhinName("events_thursday")
            case 6:
                return LocalisationDocument.sharedInstance.getStringWhinName("events_friday")
            case 7:
                return LocalisationDocument.sharedInstance.getStringWhinName("events_saturday")
            default:
                print("Error fetching days")
                return "Day"
            }
        } else {
            return ""
        }
    }
    
}
