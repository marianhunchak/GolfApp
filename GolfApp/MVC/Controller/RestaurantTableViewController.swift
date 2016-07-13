//
//  RestaurantTableViewController.swift
//  GolfApp
//
//  Created by Admin on 19.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private var reuseIdentifier = "ProsTableCell"
private let parcouseTableCellNibname = "ProsTableCell"
private let detailProsControllerIdentfier = "detailProsControllerIdentfier"

class RestaurantTableViewController: BaseTableViewController {
    
    //var restaurantArray = [Restaurant]()
    var restaurantsCount = 1
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var timer = NSTimer()
    var timer2 = NSTimer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("re_list_nav_bar")
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: parcouseTableCellNibname, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        notificationsArray = Notification.MR_findAll() as! [Notification]
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleUnregisteringNotification(_:)),
                                                         name: "notificationUnregisterd",
                                                         object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
    
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(startTimer(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false;
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.dataSource.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProsTableCell
        
        let lRestaurant = dataSource[indexPath.row] as! Restaurant
        
        cell.prosLabel.text = lRestaurant.name
        
        cell.imageForCell = lRestaurant.images.first
        let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND sid = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "restaurant", lRestaurant.id!])
        
        let lNotifications = Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]
        
        if lNotifications.count > 0 {
            cell.badgeLabel.hidden = false
            cell.badgeLabel.text = "\(lNotifications.count)"
        }
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
               let vc =  RestaurantDetailsViewContrller(nibName: "RestaurantDetailsViewContrller", bundle: nil)
        
                vc.restaurant = dataSource[indexPath.row] as? Restaurant
                vc.restaurantsCount = restaurantsCount
                vc.package_url = dataSource[indexPath.row].package_url!
        
                self.navigationController?.pushViewController(vc, animated: false)

    }
    
    // MARK: - Private methods

    func showRestaurantDetailView() {
    
        if self.dataSource.count == 1 {
            let vc =  RestaurantDetailsViewContrller(nibName: "RestaurantDetailsViewContrller", bundle: nil)
            
            vc.restaurant = dataSource[0] as? Restaurant
            vc.restaurantsCount = restaurantsCount
            vc.package_url = dataSource[0].package_url!
            
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            tableView.reloadData()
        }

    }
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = Restaurant.MR_findAllSortedBy("createdDate", ascending: true)
        restaurantsCount = dataSource.count
        print("DataSource count = \(dataSource.count)")
        tableView.reloadData()

    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getRestaurant(pPage, completion: {
            (array, error) in

            if let lArray = array {
                
                if pPage == 1{
                    if self.loadedFromDB {
                        self.dataSource = []
                        self.loadedFromDB = false
                    }
                }
            
                self.dataSource += lArray
                self.restaurantsCount = lArray.count
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
            self.showRestaurantDetailView()
            completion()
        })
        
    }
    
    // MARK: Notifications
    
    override func handleReceivedNotifications(array : [Notification]) {
        
    }
    
    override func handleNotification(notification: NSNotification) {
        
        if let notificationBody = notification.userInfo as? [String : AnyObject] {
            
            let lNotification = Notification.notificationWithDictionary(notificationBody)
            
            notificationsArray += [lNotification]
        }
    }
    
    func handleUnregisteringNotification(notification : NSNotification) {
        
        tableView.reloadData()
    }
    
    // MARK: Private methods
    
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
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(RestaurantTableViewController.checkDate), userInfo: nil, repeats: true)
        
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
    
    // MARK: Show Main controller
    
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
            
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(RestaurantTableViewController.checkDateToShowMaincontroller), userInfo: nil, repeats: true)
            
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
