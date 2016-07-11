//
//  ProShopDetailController.swift
//  GolfApp
//
//  Created by Admin on 09.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import ReachabilitySwift
import PKHUD
private let reuseIdentifier = "detailImageTableCell"
private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailImageTableCellNibName = "DetailmageTableCell"
private let detailDescriptionCellNibName = "DetailInfoCell"
private let segueIdetifireToSwipeCourseController = "showSwipeCourseController"

class ProShopDetailController: BaseViewController , ProHeaderDelegate ,UITableViewDelegate ,UITableViewDataSource{

    var proArray = [Package]()
    var prosShop : ProsShop?
    var package_url = String()
    var prosShopCount = 1
    let viewForHead = ViewForProHeader.loadViewFromNib()
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.headerView.backgroundColor = Global.viewsBackgroundColor

        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("ps_detail_nav_bar")
        
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
        self.tableView.estimatedRowHeight = 80;
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleUnregisteringNotification(_:)),
                                                         name: "notificationUnregisterd",
                                                         object: nil)
        
        let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND sid = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "proshop", prosShop!.id!])
        
        let lNotifications = Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]
        
        if lNotifications.count > 0 {
            notificationsCount = lNotifications.count
            setupHeaderView()
        } else {
            notificationsCount = 0
            setupHeaderView()
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        checkInternet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let lCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
            lCell.imagesArray = prosShop!.images
            
            return lCell
        }
            
        else if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
            cell2.nameLabel.text = prosShop!.name
            cell2.detailLabelHeight.constant = 0
            cell2.descriptionLabel.text = prosShop!.descr
            cell2.newNewsImageView.hidden = true
            return cell2
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
        cell.imagesArray = prosShop!.images
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK: Private methods
    func setupHeaderView() {
        
        if notificationsCount > 0 {
            viewForHead.badgeLabel.text = "\(notificationsCount)"
            viewForHead.badgeLabel.hidden = false
        } else {
            viewForHead.badgeLabel.hidden = true
        }
        
        viewForHead.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, headerView.frame.size.height)
        headerView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_contact_btn"), forState: .Normal)
        viewForHead.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_special_offer_nav_bar"), forState: .Normal)
        
        viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
        viewForHead.setButtonEnabled(viewForHead.button2, enabled: prosShop!.package_count!.intValue > 0 ? true : false)
        
        viewForHead.delegate = self
    }
    func pressedButton2(tableCourseHeader: ViewForProHeader, button2Pressed button2: AnyObject) {
        
        if appDelegate.reachability?.isReachable() == true {
            let packageVC = OffersController(nibName: "OffersController", bundle: nil)
            packageVC.packageUrl = prosShop!.package_url
            packageVC.titleOfferts = "ps_special_offer_nav_bar"
            packageVC.offertsArray = prosShop?.packagesList
            packageVC.prosShop = prosShop
            
            self.navigationController?.pushViewController(packageVC, animated: false)
        } else {
            HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 1.0, completion: nil)
        }
        
    }
    
    func pressedButton1(tableProHeader: ViewForProHeader, button1Pressed button1: AnyObject) {
        showContactSubView()
    }
    
    func showContactSubView() {
        
        let teeTime = TeeTimeView.loadViewFromNib()
        teeTime.title.text = LocalisationDocument.sharedInstance.getStringWhinName("pro_contact_pop_up_title")
        teeTime.emailString = prosShop!.email
        teeTime.phoneString = prosShop!.phone
        teeTime.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(teeTime)
        teeTime.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            teeTime.alpha = 1
        }
    }
    
        //MARK: Overrided methods
    
    override func showPreviousController() {
        
        if prosShopCount > 1 {
            self.navigationController?.popViewControllerAnimated(false)
            
        }else {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    func handleUnregisteringNotification(notification : NSNotification) {
        
        viewForHead.badgeLabel.hidden = true
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
