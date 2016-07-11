//
//  ProsDetailViewController.swift
//  GolfApp
//
//  Created by Admin on 10.06.16.
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


class ProsDetailViewController: BaseViewController , ProHeaderDelegate , UITableViewDelegate, UITableViewDataSource {
    
    var pros: Pros!
    var package_url = String()
    var prosCount = 1
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    let headerView = ViewForProHeader.loadViewFromNib()
    
    @IBOutlet weak var viewForHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.viewForHeader.backgroundColor = Global.viewsBackgroundColor
        
        navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_detail_nav_bar")
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        self.tableView.estimatedRowHeight = 1000

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleUnregisteringNotification(_:)),
                                                         name: "notificationUnregisterd",
                                                         object: nil)
        
        let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND sid = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "pros", pros.id!])
        
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
            lCell.imagesArray = pros.images
            
            return lCell
        }
        
        let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
        cell2.nameLabel.text = pros.name
        cell2.detailLabelHeight.constant = 0
        cell2.descriptionLabel.text = pros.descr

        cell2.newNewsImageView.hidden = true
        
        return cell2
        
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
        
        headerView.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, viewForHeader.frame.size.height)
        viewForHeader.addSubview(headerView)
        
        headerView.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("pro_contact_btn"), forState: .Normal)
        headerView.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("pro_rate_offer_btn"), forState: .Normal)
        
        headerView.button1.setButtonEnabled(true)
        headerView.button2.setButtonEnabled(pros.package_count?.intValue > 0 ? true : false)
        
        if notificationsCount > 0 {
            headerView.badgeLabel.text = "\(notificationsCount)"
            headerView.badgeLabel.hidden = false
        } else {
            headerView.badgeLabel.hidden = true
        }
        
        headerView.delegate = self
    }
    
    func pressedButton1(tableProHeader: ViewForProHeader, button1Pressed button1: AnyObject) {
        showContactSubView()
    }
    
    func pressedButton2(tableCourseHeader: ViewForProHeader, button2Pressed button2: AnyObject) {

        if appDelegate.reachability?.isReachable() == true {
            
            let packageVC = OffersController(nibName: "OffersController", bundle: nil)
            packageVC.packageUrl = pros.package_url
            packageVC.titleOfferts = "pro_rate_offer_nav_bar"
            packageVC.offertsArray = pros.packagesList
            packageVC.pros = pros
            self.navigationController?.pushViewController(packageVC, animated: false)
        } else {
            HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 1.0, completion: nil)

        }
    }
    
    func showContactSubView() {
        
        let teeTime = TeeTimeView.loadViewFromNib()
        teeTime.title.text = LocalisationDocument.sharedInstance.getStringWhinName("pro_contact_pop_up_title")
        teeTime.emailString = pros.email
        teeTime.phoneString = pros.phone
        teeTime.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.navigationController?.view.addSubview(teeTime)
        teeTime.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            teeTime.alpha = 1
        }
    }
    

    
    //MARK: Overrided methods
    
    override func showPreviousController() {
        
        if prosCount > 1 {
            self.navigationController?.popViewControllerAnimated(false)
            
        }else {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    func handleUnregisteringNotification(notification : NSNotification) {
        
        headerView.badgeLabel.hidden = true
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
