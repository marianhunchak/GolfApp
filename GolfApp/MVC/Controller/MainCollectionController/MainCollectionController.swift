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


        
        NetworkManager.sharedInstance.getNotifications { (array, error) in
            
            self.showBadges()

        }

        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleNotification(_:)),
                                                         name: "notificationRecieved",
                                                         object: nil)
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleUnregisteringNotification(_:)),
                                                         name: "notificationUnregisterd",
                                                         object: nil)
        
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

            if self.profile?.buttons?.contains(menuItemsNameArray[indexPath.row]) == true {

                cell.userInteractionEnabled =  true
            } else {
    
                imageName = imageName + "_off"
                cell.userInteractionEnabled =  false
            }
    
            cell.menuImageView.image = UIImage(named: imageName)
        
        
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
        
        print(notification.userInfo)
        
        if let lNotification = notification.object as? Notification {

            let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: menuItemsNameArray.indexOf(lNotification.post_type)!, inSection: 0)) as! MenuCollectionCell
        
            cell.badgeLabel.hidden = false
            
            cell.badgeLabel.text = "\(Int(cell.badgeLabel.text!)! + 1)"
            
        }
        
    }
    
    func handleUnregisteringNotification(notification : NSNotification) {
        
        if let postType = notification.object as? String {
        
            let cell = collectionView?.cellForItemAtIndexPath(NSIndexPath(forItem: menuItemsNameArray.indexOf(postType)!, inSection: 0)) as! MenuCollectionCell
            
            let badgeCount = Int(cell.badgeLabel.text!)! - 1
            
            if  badgeCount > 0 {
                cell.badgeLabel.text = "\(badgeCount)"
            } else {
                cell.badgeLabel.hidden = true
                cell.badgeLabel.text = "0"
            }
        }
    }
    
    
    func showBadges() {
        
        self.collectionView?.reloadData()
        dispatch_async(dispatch_get_main_queue(), { () -> Void in
            for lNotification in Notification.MR_findAll() as! [Notification] {
                
                let indexPath = NSIndexPath(forItem: self.menuItemsNameArray.indexOf(lNotification.post_type)!, inSection: 0)
                
                let cell = self.collectionView?.cellForItemAtIndexPath(indexPath) as? MenuCollectionCell
                
                cell?.badgeLabel.hidden = false
                
                cell?.badgeLabel.text = "\(Int((cell?.badgeLabel.text)!)! + 1)"
            }
        })
    }

    
}
