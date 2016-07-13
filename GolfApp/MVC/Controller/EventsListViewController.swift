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
import Alamofire

private let cellImagereuseIdentifier = "detailImageTableCell"
private let eventCellReuseIdentifier = "eventsCell"

class EventsListViewController: BaseTableViewController, ProHeaderDelegate, UIDocumentInteractionControllerDelegate {
    
    enum EventType: String {
        case Past = "past"
        case Future = "future"
    }
    
    var request: Request?
    var eventType = EventType.Future.rawValue
    var documentInteractionController : UIDocumentInteractionController?
    var headerView = ViewForProHeader.loadViewFromNib()
    
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var timer = NSTimer()
    var timer2 = NSTimer()
    
    
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
       
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(startTimer(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
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
        
        let dateString:String = event.event_date
        let dateFormat = NSDateFormatter.init()
        dateFormat.dateStyle = .FullStyle
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let dateFormat2 = NSDateFormatter.init()
        dateFormat2.dateStyle = .FullStyle
        dateFormat2.dateFormat = "dd-MM-yyyy"
        
        let date:NSDate? = dateFormat.dateFromString(dateString)
        let stringOfDateInNewFornat = dateFormat2.stringFromDate(date!)
        print(stringOfDateInNewFornat)

        cell.dataLabel.text = getDayOfWeek(event.event_date ?? "") + " " + stringOfDateInNewFornat ?? ""
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
            
            self.handleSelectionPastEvent(event)
            
        } else if eventType == EventType.Future.rawValue {
            
            let eventDV = EventDetailController(nibName: "EventDetailController", bundle: nil)
            eventDV.event = event
            self.navigationController?.pushViewController(eventDV, animated: false)
        }
        
    }
    
    //MARK: Overrided methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = Event.MR_findAllSortedBy("createdDate", ascending: true, withPredicate: NSPredicate(format: "category = %@", self.eventType))
        print("DataSource count = \(dataSource.count)")
        print("All entities count =  \(Event.MR_findAll().count)")
        tableView.reloadData()
    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {

        request = NetworkManager.sharedInstance.getEventsWithCategory(self.eventType, andPage: pPage) {
            (array, error) in
            
            if let lArray = array {

                if self.loadedFromDB {
                    self.dataSource = []
                    self.loadedFromDB = false
                }

                self.dataSource += lArray
                
                if lArray.count >= 10 {
                    self.allowLoadMore = true
                    self.allowIncrementPage = true
                    self.addInfiniteScroll()
                } else {
                    self.allowLoadMore = false
                    self.tableView.removeInfiniteScroll()
                }
                
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                
            } else if error != nil {
                self.allowIncrementPage = false
                self.handleError(error!)
            }
            
            completion()
        }
    }
    
    //MARK: Private methods
    
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
    
    func handleSelectionPastEvent(event : Event) {
        
        let url = NSURL(string: event.file_result)
        
        if event.file_result.hasPrefix("http") {
            
            HUD.show(.LabeledProgress(title: "Downloading...", subtitle: nil))
            
            Downloader.load(url!, andFileName: event.name) { (filePath) in
                
                if  let path = filePath {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        HUD.hide(animated: false)
                    })
                    
                    self.showDocumentControllerWithURL(path)
                    event.file_result = path.URLString
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        HUD.hide(animated: false)
                        HUD.flash(.Error)
                    })
                }
            }
            
        } else {
            self.showDocumentControllerWithURL(NSURL(string: event.file_result)!)
        }
        
    }
    
    func showDocumentControllerWithURL(path: NSURL) {
        
        self.documentInteractionController = UIDocumentInteractionController.init(URL:path)
        self.documentInteractionController?.delegate = self
        self.documentInteractionController?.presentPreviewAnimated(true)

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

        request?.suspend()

        tableProHeader.toggleButtons(tableProHeader.button1, btn2: tableProHeader.button2)
        self.refreshControl!.beginRefreshing()
        eventType = EventType.Future.rawValue
        dataSource = []
        tableView.reloadData()
        refresh(self.refreshControl!)
    }
    
    func pressedButton2(tableProHeader : ViewForProHeader ,button2Pressed button2 : AnyObject ) {

        request?.suspend()

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
    
    // MARK: Private methods ______!!!Do not forget to make a special class!!__
    
    func checkInternet(){
        if appDelegate.reachability?.isReachable() == true {
            NetworkManager.sharedInstance.getAdvertisemet { (aAdvertisemet) in
                self.advertisemet = aAdvertisemet
                
                self.showPopUpView()
            }
        } else {
            
            if let lAdvertisemnt = Advertisemet.MR_findFirst() {
                self.advertisemet = lAdvertisemnt as? Advertisemet
                
                showPopUpView()
            }
        }
    }
    
    func showPopUpView() {
        
        if self.isViewLoaded() && (self.view.window != nil) {
            
            let popUpView = PopUpView.loadViewFromNib()
            
            popUpView.frame = CGRectMake(0, 0,
                                         (UIApplication.sharedApplication().keyWindow?.frame.size.width)!,
                                         (UIApplication.sharedApplication().keyWindow?.frame.size.height)!)
            
            let lImage  = Image(name: (advertisemet?.name)!, url: (advertisemet?.image)!)
            
            popUpView.websiteUrl = advertisemet?.url
            popUpView.poupImage = lImage
            
            self.navigationController?.view.addSubview(popUpView)
            self.navigationController?.view.bringSubviewToFront(popUpView)
        }
    }
    
    func saveExitDate(notification : NSNotification) {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.minute = Global.timeToShowPopUp
        let todaysDate : NSDate = NSDate()
        let dateformater : NSDateFormatter = NSDateFormatter()
        dateformater.dateFormat = "MM-dd-yyyy HH:mm"
        
        let date = calendar.dateByAddingComponents(dateComponent, toDate: todaysDate, options: NSCalendarOptions.init(rawValue: 0))
        let dateInFormat = dateformater.stringFromDate(date!)
        
        if defaults.objectForKey("lastLoadDate") as? String != nil {
            
            defaults.removeObjectForKey("lastLoadDate")
        }
        
        defaults.setObject(dateInFormat, forKey: "lastLoadDate")
        defaults.synchronize()
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(EventsListViewController.checkDate), userInfo: nil, repeats: true)
        
    }
    
    func checkDate() {
        
        if self.isViewLoaded() && (self.view.window != nil) {
            
            if let lastLoaded = defaults.objectForKey("lastLoadDate") as? String {
                
                let todaysDate : NSDate = NSDate()
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat = "MM-dd-yyyy HH:mm"
                let lastLoadedDate = dateFormater.dateFromString(lastLoaded)
                
                let showPopUp = lastLoadedDate?.compare(todaysDate)
                let dateInFormat = dateFormater.stringFromDate(todaysDate)
                print(dateInFormat)
                if showPopUp == .OrderedAscending {
                    
                    print("Time to show Pop Up View!")
                    checkInternet()
                    timer2.invalidate()
                    if defaults.objectForKey("lastLoadDate") as? String != nil {
                        
                        defaults.removeObjectForKey("lastLoadDate")
                        defaults.synchronize()
                    }
                    
                } else if  showPopUp == .OrderedDescending {
                    print("This is not time to show Pop Up View!")
                    timer2.invalidate()
                    if defaults.objectForKey("lastLoadDate") as? String != nil {
                        
                        defaults.removeObjectForKey("lastLoadDate")
                        defaults.synchronize()
                    }
                }
            }
        }
    }
    
    // MARK: Show Main controller ______!!!Do not forget to make a special class!!__
    
    func startTimer(notification : NSNotification) {
        if self.isViewLoaded() && (self.view.window != nil) {
            
            if defaults.objectForKey("lastPressedHome") as? String != nil {
                
                defaults.removeObjectForKey("lastPressedHome")
                defaults.synchronize()
            }
            
            let calendar = NSCalendar.currentCalendar()
            let dateComponent = NSDateComponents()
            dateComponent.minute = Global.timeToShowMainController
            let todaysDate : NSDate = NSDate()
            let dateformater : NSDateFormatter = NSDateFormatter()
            dateformater.dateFormat = "MM-dd-yyyy HH:mm"
            let date = calendar.dateByAddingComponents(dateComponent, toDate: todaysDate, options: NSCalendarOptions.init(rawValue: 0))
            let dateInFormat = dateformater.stringFromDate(date!)
            
            if defaults.objectForKey("lastPressedHome") as? String != nil {
                
                defaults.removeObjectForKey("lastPressedHome")
            }
            
            defaults.setObject(dateInFormat, forKey: "lastPressedHome")
            defaults.synchronize()
            
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(EventsListViewController.checkDateToShowMaincontroller), userInfo: nil, repeats: true)
            
        }
        
    }
    
    func checkDateToShowMaincontroller() {
        if self.isViewLoaded() && (self.view.window != nil) {
            
            if let lastLoaded = defaults.objectForKey("lastPressedHome") as? String {
                
                let todaysDate : NSDate = NSDate()
                let dateFormater = NSDateFormatter()
                dateFormater.dateFormat = "MM-dd-yyyy HH:mm"
                let dateInFormat = dateFormater.stringFromDate(todaysDate)
                print(dateInFormat)
                let lastLoadedDate = dateFormater.dateFromString(lastLoaded)
                
                let showMaincontroller = lastLoadedDate?.compare(todaysDate)
                
                if showMaincontroller == .OrderedAscending {
                    
                    if defaults.objectForKey("lastPressedHome") as? String != nil {
                        
                        defaults.removeObjectForKey("lastPressedHome")
                        defaults.synchronize()
                    }
                    timer.invalidate()
                    
                    self.navigationController?.popToRootViewControllerAnimated(false)
                    
                } else if  showMaincontroller == .OrderedDescending{
                    
                    timer.invalidate()
                    if defaults.objectForKey("lastPressedHome") as? String != nil {
                        
                        defaults.removeObjectForKey("lastPressedHome")
                        defaults.synchronize()
                    }
                }
                
            }
        }
    }
    
}