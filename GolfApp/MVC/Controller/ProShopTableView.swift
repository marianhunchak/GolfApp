//
//  ProShopTableView.swift
//  GolfApp
//
//  Created by Admin on 19.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellIdentifier = "parcoursCell"
private let detailProShopControllerIdentfier = "ProShopDetailViewController"

class ProShopTableView: BaseTableViewController {

    var prosShopCount = 1
    
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("ps_list_nav_bar")
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: "CoursTableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleUnregisteringNotification(_:)),
                                                         name: "notificationUnregisterd",
                                                         object: nil)

        notificationsArray = Notification.MR_findAll() as! [Notification]
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        checkInternet()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CoursTableCell
        cell.cellInfoLabelHeight.constant = 0
        cell.badgeLabel.text = nil
        cell.badgeLabel.hidden = true
        let lProsShop = dataSource[indexPath.row] as! ProsShop
        
        cell.cellItemLabel.text = lProsShop.name
        cell.imageForCell = lProsShop.images.first
        
        let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND sid = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "proshop", lProsShop.id!])
        
        let lNotifications = Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]
        
        if lNotifications.count > 0 {
            cell.badgeLabel.hidden = false
            cell.badgeLabel.text = "\(lNotifications.count)"
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height / 3
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        let vc = ProShopDetailController(nibName: "ProShopDetailController", bundle: nil)
        
        vc.package_url = dataSource[indexPath.row].package_url!
        vc.prosShop = dataSource[indexPath.row] as? ProsShop
        vc.prosShopCount = prosShopCount
        self.navigationController?.pushViewController(vc, animated: false)
       
    }
    // MARK: - Private methods
    
    func showProShopDetailView() {
        
        if self.dataSource.count == 1 {
            let vc =  ProShopDetailController(nibName: "ProShopDetailController", bundle: nil)
            
            vc.prosShop = dataSource[0] as? ProsShop
            vc.prosShopCount = prosShopCount
            vc.package_url = dataSource[0].package_url!
            
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            
            tableView.reloadData()
            
        }
        
    }
    
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = ProsShop.MR_findAllSortedBy("createdDate", ascending: true)
        prosShopCount = dataSource.count
        print("DataSource count = \(dataSource.count)")
        tableView.reloadData()

    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getProsShop(pPage, completion: {
            (array, error) in
            
            if let lArray = array {
                
                if pPage == 1 {
                    
                    if self.loadedFromDB {
                        self.dataSource = []
                        self.loadedFromDB = false
                    }
                    
                }

                self.dataSource += lArray
                self.prosShopCount == self.dataSource.count
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
            self.showProShopDetailView()
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

