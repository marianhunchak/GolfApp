//
//  OffersController.swift
//  GolfApp
//
//  Created by Admin on 10.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import MagicalRecord


private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailDescriptionCellNibName = "DetailInfoCell"

class OffersController: BaseViewController , OffersHeaderDelegate,UITableViewDelegate, UITableViewDataSource{
    
    let viewForHead = ViewForOffersHeader.loadViewFromNib()
    var seleted = false
    var shareItem = -1
    var offertsArray : [Package]?
    var packageUrl: String?
    var titleOfferts = "re_suggestion_nav_bar"
    var hotel : Hotel?
    var pros : Pros!
    var prosShop : ProsShop!
    var restaurant : Restaurant?
    var sid : NSNumber?
    var post_id : NSNumber?
    var openFromDetailVC = true
    var id : NSNumber?
    var notific = [Notification]()
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var timer = NSTimer()
    var timer2 = NSTimer()
    
    @IBOutlet weak var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName(titleOfferts)
        
        self.configureNavBar()
        setupHeaderView()
        
        let no : [Notification] = Notification.MR_findAll() as! [Notification]
        print(no.count)
        print(no)
        
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        self.tableView.estimatedRowHeight = 80;
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)

        
        if id != nil {
            NSNotificationCenter.defaultCenter().addObserver(self,
                                                             selector: #selector(handleNotification(_:)),
                                                             name: "notificationRecieved",
                                                             object: nil)
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(startTimer(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
    
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if shareItem != -1 {
            tableView.delegate?.tableView!(tableView, didDeselectRowAtIndexPath: NSIndexPath(forRow: shareItem, inSection: 0))
        }
        
        viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
        shareItem = indexPath.row
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! DetailInfoCell
        selectedCell.setCellSelected()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let deselectedCell = tableView.cellForRowAtIndexPath(indexPath) as? DetailInfoCell {
            deselectedCell.backgroundCourseFooter.backgroundColor = Global.descrTextBoxColor
            deselectedCell.nameLabel.textColor = Global.navigationBarColor
            deselectedCell.backgroundCourseFooter.layer.borderWidth = 0.0
        }
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return offertsArray == nil ? 0 : offertsArray!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
        //cell.displayNewNewsImage = nil
        cell.newNewsImageView.hidden = true
        
        let lPackage = offertsArray![indexPath.row]
        cell.nameLabel.text = lPackage.name
        cell.detailLabel.text = lPackage.subtitle
        cell.descriptionLabel.text = lPackage.descr
        cell.tag = indexPath.row
        cell.tableView = tableView
        if shareItem == indexPath.row {
            cell.setCellSelected()
        }

        // Mark : fix in the future -> create for this special class
        
        switch titleOfferts {
        case "re_suggestion_nav_bar":
            let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND post_id = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "restaurant", lPackage.id])
            let notification = Notification.MR_findAll() as! [Notification]
            print(notification)
            if  Notification.MR_findFirstWithPredicate(lPredicate) as? Notification != nil {
                cell.displayNewNewsImage = true
            } else if lPackage.id == post_id{
                cell.displayNewNewsImage = true
            }
        case "ps_special_offer_nav_bar":
            let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND post_id = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "proshop", lPackage.id])
            let notification = Notification.MR_findAll() as! [Notification]
            print(notification)
            if  Notification.MR_findFirstWithPredicate(lPredicate) as? Notification != nil {
                cell.displayNewNewsImage = true
            } else if lPackage.id == post_id {
                cell.displayNewNewsImage = true
            }
        case "pro_rate_offer_nav_bar":
            //cell.displayNewNewsImage = true
            let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND post_id = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "pros", lPackage.id])
            let notification = Notification.MR_findAll() as! [Notification]
            notific = notification
            print(notification)
            print(notification.count)
            if  Notification.MR_findFirstWithPredicate(lPredicate) as? Notification != nil {
                cell.displayNewNewsImage = true
            } else if lPackage.id == post_id {
                cell.displayNewNewsImage = true
            }
        case "htl_package_list_nav_bar":
            let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND post_id = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "hotel", lPackage.id])
            let notification = Notification.MR_findAll() as! [Notification]
            print(notification)
            if  Notification.MR_findFirstWithPredicate(lPredicate) as? Notification != nil {
                cell.displayNewNewsImage = true
            } else if lPackage.id == post_id {
                print(lPackage.id)
                print(post_id)
                cell.displayNewNewsImage = true
            }

            
        default: break
            
        }
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    //MARK: Private methods
    
    func setupHeaderView() {
        
        viewForHead.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, backgroundView.frame.size.height)
        backgroundView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_share_btn"), forState: .Normal)
        viewForHead.delegate = self
        
    }
    
    func pressedButton1(tableProHeader: ViewForOffersHeader, button1Pressed button1: AnyObject) {
        
        let lPackege = offertsArray![shareItem]
        let textToShare = lPackege.name + "\n" + lPackege.subtitle + "\n" + lPackege.descr
        let urlToShare = "http://golfapp.ch"
        
        if let myWebsite = NSURL(string: urlToShare) {
            let activityVC = UIActivityViewController(activityItems: [myWebsite, textToShare], applicationActivities: [])
            self.navigationController!.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    

    override func refresh(sender: AnyObject) {
        
        if offertsArray != nil {
            
            if offertsArray!.isEmpty {
                refreshControl?.beginRefreshing()
            }
        }
        

        
        loadDataFromServer()
    }
    
   // Mark : downloading data (test version) fix in the future
    
    func loadDataFromServer() {
        
        switch titleOfferts {
            
        case "re_suggestion_nav_bar":
            
            if sid == nil {
                id = restaurant!.id!
            } else {
                id = sid
            }
            
            NetworkManager.sharedInstance.getSuggestions(openFromDetailVC , packagesType : "restaurant" ,ID : id! ,urlToPackage: packageUrl ?? "") { (array) in
                
                if let lArray = array {
                    self.offertsArray = lArray
                    self.tableView.reloadData()
                    print(self.packageUrl)
                    if self.restaurant != nil{
                        self.restaurant?.packagesList = array
                        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                        self.removeDispatch_Async(self.restaurant!.id!, postType: "restaurant")
                    } else {
                        self.removeDispatch_Async(self.sid!, postType: "restaurant")
                    }
                } 

                self.refreshControl?.endRefreshing()
            } 
        case "ps_special_offer_nav_bar":
            
            if sid == nil {
                id = prosShop.id!
            } else {
                id = sid
            }
            
            NetworkManager.sharedInstance.getPackages(openFromDetailVC , packagesType : "proshop" ,ID : id! ,urlToPackage: packageUrl ?? "") { (array) in
   
                if let lArray = array {
                    self.offertsArray = lArray
                    self.tableView.reloadData()
                    print(self.packageUrl)
                    if self.prosShop != nil {
                        self.prosShop.packagesList = array
                        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                        self.removeDispatch_Async(self.prosShop.id!, postType: "proshop")
                    } else {
                        self.removeDispatch_Async(self.sid!, postType: "proshop")
                    }

                } 
                self.refreshControl?.endRefreshing()
            }
        case "pro_rate_offer_nav_bar":
            
            if sid == nil {
                id = pros.id!
            } else {
                id = sid
            }
            
            NetworkManager.sharedInstance.getPackages(openFromDetailVC , packagesType : "pros" ,ID : id! ,urlToPackage: packageUrl ?? "") { (array) in
                
                if let lArray = array {
                    self.offertsArray = lArray
                    self.tableView.reloadData()
                    print(self.packageUrl)
                    if self.pros != nil {
                        self.pros.packagesList = array!
                         NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                         self.removeDispatch_Async(self.pros.id!, postType: "pros")
                    } else {
                        self.removeDispatch_Async(self.sid!, postType: "pros")
                    }
                }
                
                self.refreshControl?.endRefreshing()

            }
            
        case "htl_package_list_nav_bar":
            
            if sid == nil {
                id = hotel!.id!
            } else {
                id = sid
            }
            
            NetworkManager.sharedInstance.getPackages(openFromDetailVC , packagesType : "hotel" ,ID : id! ,urlToPackage: packageUrl ?? "") { (array) in
                
                if let lArray = array {
                    
                    self.offertsArray = lArray
                    self.tableView.reloadData()
                    print(self.packageUrl)
                    if self.hotel != nil {
                        self.hotel!.packagesList = lArray
                        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                        self.removeDispatch_Async(self.hotel!.id, postType: "hotel")
                    } else if self.sid != nil {
                        self.removeDispatch_Async(self.sid!, postType: "hotel")
                    }
 
                }
                self.refreshControl?.endRefreshing()

            }
            
        default:
            break
        }
        
    }
    
    func removeDispatch_Async(ID : NSNumber, postType: String) {
        
            dispatch_async(dispatch_get_main_queue(), { () -> Void in

                self.removeNotificationsWithsID(ID, andPostType: postType)
            })
        
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
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(OffersController.checkDate), userInfo: nil, repeats: true)
        
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
    
    
    // MARK: Notifications
    
    func handleNotification(notification : NSNotification) {
        
        NetworkManager.sharedInstance.getNotifications { (array, error) in

            self.tableView.reloadData()

            
            switch self.titleOfferts {
                
                
            case "re_suggestion_nav_bar":
            
                if self.isViewLoaded() && (self.view.window != nil) {
                    
                    self.removeDispatch_Async(self.id!, postType: "restaurant")
                }

                
            case "ps_special_offer_nav_bar":
                
                if self.isViewLoaded() && (self.view.window != nil) {
                    
                    self.removeDispatch_Async(self.id!, postType: "proshop")
                }


            case "pro_rate_offer_nav_bar":
                
                if self.isViewLoaded() && (self.view.window != nil) {
                    
                    self.removeDispatch_Async(self.id!, postType: "pros")
                }

                
            case "htl_package_list_nav_bar":
                
                if self.isViewLoaded() && (self.view.window != nil) {
                        self.removeDispatch_Async(self.id!, postType: "hotel")
                }
                
            default:
                break
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
            
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(OffersController.checkDateToShowMaincontroller), userInfo: nil, repeats: true)
            print(timer)
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
