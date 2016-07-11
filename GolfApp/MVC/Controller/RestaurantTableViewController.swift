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
        checkInternet()
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
                self.checkDate()
                
            }
        } else {
            
            if let lAdvertisemnt = Advertisemet.MR_findFirst() {
                self.advertisemet = lAdvertisemnt as? Advertisemet
                self.checkDate()
            }
        }
    }
    
    func showPopUpView() {
        
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
    
    func saveExitDate(notification : NSNotification) {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.second = 10
        let todaysDate : NSDate = NSDate()
        let dateformater : NSDateFormatter = NSDateFormatter()
        dateformater.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        let date = calendar.dateByAddingComponents(dateComponent, toDate: todaysDate, options: NSCalendarOptions.init(rawValue: 0))
        let dateInFormat = dateformater.stringFromDate(date!)
        
        defaults.setObject(dateInFormat, forKey: "lastLoadDate")
        defaults.synchronize()
        
    }
    
    func checkDate() {
        
        if let lastLoaded = defaults.objectForKey("lastLoadDate") as? String {
            
            let todaysDate : NSDate = NSDate()
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "MM-dd-yyyy HH:mm:ss"
            let lastLoadedDate = dateFormater.dateFromString(lastLoaded)
            
            let showPopUp = lastLoadedDate?.compare(todaysDate)
            
            if showPopUp == .OrderedAscending {
                
                print("Time to show Pop Up View!")
                showPopUpView()
                
            } else {
                print("This is not time to show Pop Up View!")
            }
            
        }
    }
    
}
