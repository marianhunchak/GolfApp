//
//  MainCollectionController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "menuCollectionCell"
private let nibNameMenuCollectionCell = "MenuCollectionCell"
private let nameForBackgroundImage = "a_home_6"
private let identifierOfListTableController = "ListTableController"
private var identifierOfProsListViewController = "ProsListViewController"



class MainCollectionController: UICollectionViewController {
    
    var profile:Profile?
    var prosArray = [Pros]()
    var lTopInset : CGFloat?
    var img = [String]()
    var buttonEnabled = [Bool]()
    var timer2 = NSTimer()
    
    
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
        var buttonsItemsImgOnArray = ["a_pros",     "a_tee_time",   "a_events",
                                      "a_proshop" , "a_courses",    "a_hotel",
                                      "a_contact",  "a_news",       "a_restaurant"]
    
        var buttonsItemsImgOfArray = ["a_pros_off",     "a_tee_time_off",   "a_events_off",
                                      "a_proshop_off" , "a_courses_off",    "a_hotel_off",
                                      "a_contact_off",  "a_news_off",       "a_restaurant_off"]
    
        var menuFilesNameArray = ["hm_pros_btn",     "hm_tee_time_btn",  "hm_events_btn",
                                  "hm_proshp_btn",   "hm_courses_btn",   "hm_htls_btn",
                                  "hm_contact_btn",  "hm_news_btn",      "hm_rest_btn"]
    
        var menuItemsImgArray = ["a_pros", "a_tee_time", "a_events", "a_proshop", "a_courses", "a_hotel", "a_contact", "a_news", "a_restaurant"]
    
        var menuItemsNameArray = ["pros",     "teetime",  "events",
                                  "proshop" , "courses",  "hotel",
                                  "contact",  "news",     "restaurant"]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        lTopInset = self.view.center.y
        let backroundImage = UIImageView.init(image: UIImage.init(named:nameForBackgroundImage))
        backroundImage.frame = self.view.frame
        self.collectionView?.backgroundView = backroundImage
        
        let nib = UINib(nibName: nibNameMenuCollectionCell, bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        if let lProfile = Profile.MR_findFirst() as? Profile {
            self.profile = lProfile
        }
        
        NetworkManager.sharedInstance.getProfileAndAvertising { (pProfile) in
            self.profile = pProfile
            self.collectionView!.reloadData()
        }

        checkInternet()
        getNotifications()

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleNotification(_:)),
                                                         name: "notificationRecieved",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleUnregisteringNotification(_:)),
                                                         name: "notificationUnregisterd",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
        
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
//        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    //MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MenuCollectionCell
        cell.menuLabel.text =  LocalisationDocument.sharedInstance.getStringWhinName(menuFilesNameArray[indexPath.row])

            var imageName = buttonsItemsImgOnArray[indexPath.row]
            cell.badgeLabel.hidden = true
            if self.profile?.buttons?.contains(menuItemsNameArray[indexPath.row]) == true {

                cell.userInteractionEnabled =  true
            } else {
    
                imageName = imageName + "_off"
                cell.userInteractionEnabled =  false
            }
    
            cell.menuImageView.image = UIImage(named: imageName)
        
        for lNotification in Notification.MR_findAll() as! [Notification] {
            
            let all = Notification.MR_findAll() as! [Notification]
            print(all.count)
            
            if lNotification.post_type == "restaurant" {
                
                let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ ", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "restaurant"])
                
               let allCount =  Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]


                if 8 == indexPath.row {
                    cell.badgeLabel.hidden = false
                    cell.badgeLabel.text = "\(allCount.count)"
                }

            } else if lNotification.post_type == "proshop" {
                
                let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ ", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "proshop"])
                
                let allCount =  Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]
                
                if indexPath.row == 3 {

                    cell.badgeLabel.hidden = false
                    cell.badgeLabel.text = "\(allCount.count)"
                }

            } else if lNotification.post_type == "pros" {
                
                let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ ", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "pros"])
                
                let allCount =  Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]

                if indexPath.row == 0 {

                    cell.badgeLabel.hidden = false
                    cell.badgeLabel.text = "\(allCount.count)"
                    print("\(allCount.count)")
                
                }
            } else if lNotification.post_type == "hotel" {
                
                let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ ", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "hotel"])
                
                let allCount =  Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]

                if indexPath.row == 5 {
                    cell.badgeLabel.hidden = false
                    cell.badgeLabel.text = "\(allCount.count)"
                }
            } else if lNotification.post_type == "news" {

                if indexPath.row == 7 {
                    
                    let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ ", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "news"])
                    
                    let allCount =  Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]
                    
                    cell.badgeLabel.hidden = false
                    cell.badgeLabel.text = "\(allCount.count)"
                }
            }

        }
        
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.item {
            case 0:
                let prosVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProsListTableViewController")
                self.navigationController?.pushViewController(prosVC!, animated: false)
            case 1:
                showTeeTimeSubView()
            case 2:
                let eventsVC =  EventsListViewController(nibName: "EventsListController", bundle: nil)
                self.navigationController?.pushViewController(eventsVC, animated: false)
            case 3:
                let proShopVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProShopTableView")
                self.navigationController?.pushViewController(proShopVC!, animated: false)
            case 4:
                let coursesVC = self.storyboard?.instantiateViewControllerWithIdentifier(identifierOfListTableController)
                self.navigationController?.pushViewController(coursesVC!, animated: false)
            case 5:
                let hotelsVC = HotelsTableViewController(nibName: "HotelsTableViewController", bundle: nil)
                self.navigationController?.pushViewController(hotelsVC, animated: false)
            case 6:
                showContactSubView()
            case 7:
                let newsVC = self.storyboard?.instantiateViewControllerWithIdentifier("NewsTableViewController") as! NewsTableViewController
                self.navigationController?.pushViewController(newsVC, animated: false)
            case 8:
                let restaurantVC = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantTableViewController")
                self.navigationController?.pushViewController(restaurantVC!, animated: false)
            
            default: break
        
        }
    }
}

extension MainCollectionController : UICollectionViewDelegateFlowLayout {
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let lCellWidth:CGFloat = self.view.frame.width / 3.0 - 10.0;
        let lcellHeigt:CGFloat = (self.view.frame.height - lTopInset!) / 3.0 - 15.0 
        return CGSize(width: lCellWidth, height: lcellHeigt)
    }
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: lTopInset!, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
    //MARK: Private methods
    
    func showContactSubView() {
        
        let contact = ContactView.loadViewFromNib()
        contact.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(contact)
        contact.emailString = profile?.email
        contact.phoneString = profile?.phone
        contact.latitude = profile?.latitude
        contact.longitude = profile?.longitude
        contact.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            contact.alpha = 1
        }
    }
    
    func showTeeTimeSubView() {
    
        let teeTime = TeeTimeView.loadViewFromNib()
        teeTime.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        teeTime.emailString = profile?.email
        teeTime.phoneString = profile?.phone
        self.view.addSubview(teeTime)
        teeTime.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            teeTime.alpha = 1
        }
    }
    
    // MARK: Notifications
    
    func handleNotification(notification : NSNotification) {
        

       self.collectionView?.reloadData()
    }
    
    func handleUnregisteringNotification(notification : NSNotification) {
        

        self.collectionView?.reloadData()
    }
    
    func getNotifications() {
        NetworkManager.sharedInstance.getNotifications { (array, error) in
            
            self.collectionView?.reloadData()
            
        }
    
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
    
            let popUpView = PopUpView.loadViewFromNib()
    
            popUpView.frame = CGRectMake(0, 0,
                                         (UIApplication.sharedApplication().keyWindow?.frame.size.width)!,
                                         (UIApplication.sharedApplication().keyWindow?.frame.size.height)!)
    
            let lImage  = Image(name: (advertisemet?.name)!, url: (advertisemet?.image)!)
    
            popUpView.websiteUrl = advertisemet?.url
            popUpView.poupImage = lImage
    
            self.view.addSubview(popUpView)
            self.view.bringSubviewToFront(popUpView)
    
        }
    
    func saveExitDate(notification : NSNotification) {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.second = Global.timeToShowPopUp
        let todaysDate : NSDate = NSDate()
        let dateformater : NSDateFormatter = NSDateFormatter()
        dateformater.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        let date = calendar.dateByAddingComponents(dateComponent, toDate: todaysDate, options: NSCalendarOptions.init(rawValue: 0))
        let dateInFormat = dateformater.stringFromDate(date!)
        
        if defaults.objectForKey("lastLoadDate") as? String != nil {
            
            defaults.removeObjectForKey("lastLoadDate")
        }
        
        defaults.setObject(dateInFormat, forKey: "lastLoadDate")
        defaults.synchronize()
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(MainCollectionController.checkDate), userInfo: nil, repeats: true)
        
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
