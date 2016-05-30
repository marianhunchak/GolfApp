//
//  EventsViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/23/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import PKHUD
import MagicalRecord

private let cellImagereuseIdentifier = "detailImageTableCell"
private let eventCellReuseIdentifier = "eventsCell"

class EventsListViewController: BaseTableViewController, ProHeaderDelegate, UIDocumentInteractionControllerDelegate {
    
    enum EventType: String {
        case Past = "past"
        case Future = "future"
    }
    
    var eventType = EventType.Future.rawValue
    var eventsArray = [Event]()
    var documentInteractionController : UIDocumentInteractionController?
    var headerView = ViewForProHeader.loadViewFromNib()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        self.setupHeaderView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top + Global.headerHeight,
                                              left: 0,
                                              bottom: Global.pading,
                                              right: 0)
        
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("evt_list_view_nav_bar")
        self.view.backgroundColor = Global.viewsBackgroundColor
        
        let nibFood = UINib.init(nibName: "EventsTableCell", bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: eventCellReuseIdentifier)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.headerView.removeFromSuperview()
    }
    
    //MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(eventCellReuseIdentifier, forIndexPath: indexPath) as! EventsTableCell
        
        let event = dataSource[indexPath.row] as! Event
        cell.dataLabel.text = getDayOfWeek(event.event_date) + " " + event.event_date
        cell.eventNameLabel.text = event.name
        cell.eventDescrLabel.text = event.format
        
        if eventType == EventType.Past.rawValue {
            if event.file_result.isEmpty {
                cell.hideImage()
            } else {
                cell.cellImageView?.image = UIImage(named: "a_winner_icon")
                cell.imageHeight.constant = 40.0
                cell.showImage()
            }
        } else {
            cell.cellImageView?.image = UIImage(named: "a_forward_btn")
            cell.imageHeight.constant = 25.0
            cell.showImage()
        }
        
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension

    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let event = dataSource[indexPath.row] as! Event
        
        if eventType == EventType.Past.rawValue && !event.file_result.isEmpty {
            let url = NSURL(string: event.file_result)
            
            HUD.show(.LabeledProgress(title: "Downloading...", subtitle: nil))
            
            Downloader.load(url!) { (filePath) in
                if  let path = filePath {
                    dispatch_async(dispatch_get_main_queue(), {
                        HUD.hide(animated: false)
                    })
                    self.documentInteractionController = UIDocumentInteractionController.init(URL:path)
                    self.documentInteractionController?.delegate = self
                    self.documentInteractionController?.presentPreviewAnimated(true)
                }
            }
        } else if eventType == EventType.Future.rawValue {
            
            let eventDV = EventDetailController(nibName: "EventDetailController", bundle: nil)
            eventDV.event = event
            self.navigationController?.pushViewController(eventDV, animated: false)
        }
        
    }
    
    //MARK: Private methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = Event.MR_findByAttribute("category", withValue: self.eventType)
        print("DataSource count = \(dataSource.count)")
        print(Event.MR_findAll().count)
        tableView.reloadData()
        refreshControl?.endRefreshing()
    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {

        NetworkManager.sharedInstance.getEventsWithCategory(self.eventType, andPage: pPage) {
            (array, error) in
            
            if self.loadedFromDB {
                self.dataSource = []
                self.loadedFromDB = false
            }
            
            if let lArray = array {
                
                self.dataSource += lArray
                if lArray.count >= 10 {
                    self.allowLoadMore = true
                    self.allowIncrementPage = true
                    self.addInfiniteScroll()
                } else {
                    self.allowLoadMore = false
                    self.tableView.removeInfiniteScroll()
                }
                completion()
            } else if error != nil {
                self.allowIncrementPage = false
                self.handleError(error!)
                completion()
            }
        }
    }
    
    func setupHeaderView() {

        headerView.frame = CGRectMake(0.0,
                                     (self.navigationController?.navigationBar.frame.maxY)!,
                                     Global.displayWidth,
                                     Global.headerHeight)
        
        self.navigationController?.view.addSubview(headerView)
        self.navigationController?.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
        
        headerView.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("evt_upcoming_event_btn"), forState: .Normal)
        headerView.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("evt_pastevent_btn"), forState: .Normal)
        headerView.delegate = self
    }
    
    func getDayOfWeek(today:String) -> String {
        
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
    
    
    //MARK: ProHeaderDelegate
    
    func pressedButton1(tableProHeader : ViewForProHeader ,button1Pressed button1 : AnyObject ) {
        
        tableProHeader.toggleButtons(tableProHeader.button1, btn2: tableProHeader.button2)
        self.refreshControl!.beginRefreshing()
        eventType = EventType.Future.rawValue
        dataSource = []
        tableView.reloadData()
        refresh(self.refreshControl!)
    }
    
    func pressedButton2(tableProHeader : ViewForProHeader ,button2Pressed button2 : AnyObject ) {
        
        tableProHeader.toggleButtons(tableProHeader.button2, btn2: tableProHeader.button1)
        self.refreshControl!.beginRefreshing()
        eventType = EventType.Past.rawValue
        dataSource = []
        tableView.reloadData()
        refresh(self.refreshControl!)
    }
    
    //MARK: UIDocumentInteractionControllerDelegate
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
}