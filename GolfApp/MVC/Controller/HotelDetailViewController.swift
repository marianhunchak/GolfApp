//
//  HotelDetailViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/17/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import ReachabilitySwift
import PKHUD

private let cellImagereuseIdentifier = "detailImageTableCell"
private let courseFooterIndetifire = "courseFooterIndetifire"

class HotelDetailViewController: BaseViewController , CourseHeaderDelegate, UITableViewDelegate, UITableViewDataSource {

    var hotel: Hotel!
    var hotelsCount = 1
    let viewForHeader = ViewForDetailHeader.loadViewFromNib()
    
    @IBOutlet weak var headerView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("htl_detail_nav_bar")
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.headerView.backgroundColor = Global.viewsBackgroundColor

        
        let nib = UINib.init(nibName: "DetailmageTableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellImagereuseIdentifier)
        
        let nibFood = UINib.init(nibName: "DetailInfoCell", bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        self.tableView.estimatedRowHeight = 1000
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleUnregisteringNotification(_:)),
                                                         name: "notificationUnregisterd",
                                                         object: nil)
        
        let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND sid = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "hotel", hotel.id!])
        
        let lNotifications = Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]
        
        if lNotifications.count > 0 {
            notificationsCount = lNotifications.count
            setupHeaderView()
        } else {
            notificationsCount = 0
            setupHeaderView()
        }
    }
    
    //MARK: UITableViewDataSource
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let lCell = tableView.dequeueReusableCellWithIdentifier(cellImagereuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
            lCell.imagesArray = self.hotel.images
            
            return lCell
        }
        
        let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
        cell2.detailLabelHeight.constant = 0
        cell2.nameLabel.text = hotel.name
        cell2.descriptionLabel.text = hotel.descr
        cell2.newNewsImageView.hidden = true    
            return cell2
    }
    
    //MARK: Private methods
    func setupHeaderView() {
        
        viewForHeader.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, headerView.frame.size.height)
        headerView.addSubview(viewForHeader)
        
        viewForHeader.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("htl_contact_pop_up_title"), forState: .Normal)
        viewForHeader.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("htl_website_btn"), forState: .Normal)
        viewForHeader.button3.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("htl_package_btn"), forState: .Normal)
        
        viewForHeader.setButtonEnabled(viewForHeader.button1, enabled: true)
        viewForHeader.setButtonEnabled(viewForHeader.button2, enabled: hotel.website.isEmpty ? false : true)
        viewForHeader.setButtonEnabled(viewForHeader.button3, enabled: hotel.package_count.intValue > 0 ? true : false)
        if notificationsCount > 0 {
            viewForHeader.badgeLabel.text = "\(notificationsCount)"
            viewForHeader.badgeLabel.hidden = false
        } else {
            viewForHeader.badgeLabel.hidden = true
        }
        
        viewForHeader.delegate = self
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3.0
        }
        
        return UITableViewAutomaticDimension
    }
    
    //MARK: CourseHeaderDelegate
    
    func tableCourseHeader(tableCourseHeader: ViewForDetailHeader, button1Pressed button1: AnyObject) {
            
        let contact = ContactView.loadViewFromNib()
        contact.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(contact)
        contact.phoneString = hotel.phone
        contact.emailString = hotel.email
        contact.longitude = hotel.longitude
        contact.latitude = hotel.latitude
        contact.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            contact.alpha = 1
        }
    }
    
    func pressedButton2(tableCourseHeader: ViewForDetailHeader, button2Pressed button2: AnyObject) {
        
        if let checkURL = NSURL(string: hotel.website) {
            if UIApplication.sharedApplication().openURL(checkURL) {
                print("url successfully opened")
            }
        } else {
            let openUrlErrorAlert = UIAlertView(title: "GolfApp can not open browser!", message: "GolfApp can not open browser ,because no url address!!", delegate: self, cancelButtonTitle: "Ok")
            openUrlErrorAlert.show()
        }

    }
    
    func pressedButton3(tableCourseHeader: ViewForDetailHeader, button3Pressed button2: AnyObject) {

        if appDelegate.reachability?.isReachable() == true {
            
            
            let packageVC = OffersController(nibName: "OffersController", bundle: nil)
            packageVC.packageUrl = hotel.package_url
            packageVC.titleOfferts = "htl_package_list_nav_bar"
            packageVC.offertsArray = hotel.packagesList
            packageVC.hotel = hotel
            
            self.navigationController?.pushViewController(packageVC, animated: false)
        } else {
            HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 1.0, completion: nil)
            
        }

    }
    
    //MARK: Overrided methods
    
    override func showPreviousController() {
        
        if hotelsCount > 1 {
            self.navigationController?.popViewControllerAnimated(false)
            
        } else {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }

    func handleUnregisteringNotification(notification : NSNotification) {
        
        viewForHeader.badgeLabel.hidden = true
    }
    
}
