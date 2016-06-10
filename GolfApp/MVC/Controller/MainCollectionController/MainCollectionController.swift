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
private let nameForBackgroundImage = "a_home"
private let identifierOfListTableController = "ListTableController"
private var identifierOfProsListViewController = "ProsListViewController"

class MainCollectionController: UICollectionViewController  {
    
    var profile:Profile?
    var prosArray = [Pros]()
    var lTopInset : CGFloat?
    var buttonsItemsImgOnArray = ["a_tee_time", "a_restaurant",   "a_events",
                                  "a_proshop" , "a_courses",      "a_pros",
                                  "a_contact",  "a_news",         "a_hotel"]
    
    var buttonsItemsImgOfArray = ["a_tee_time_off", "a_restaurant_off",   "a_events_off",
                                  "a_proshop_off" , "a_courses_off",      "a_pros_off",
                                  "a_contact_off",  "a_news_off",         "a_hotel_off"]
    
    var buttonsItemsNamefArray = ["a_tee_time", "a_restaurant_off",   "a_events_off",
                                  "a_proshop_off" , "a_courses_off",      "a_pros_off",
                                  "a_contact_off",  "a_news_off",         "a_hotel_off"]
    
    
    var menuFilesNameArray = ["hm_tee_time_btn", "hm_rest_btn",    "hm_events_btn",
                              "hm_proshp_btn",   "hm_courses_btn", "hm_pros_btn",
                              "hm_contact_btn",  "hm_news_btn",    "hm_htls_btn"]
    
    var menuItemsImgArray = ["a_tee_time", "a_restaurant", "a_events", "a_proshop", "a_courses", "a_pros", "a_contact", "a_news", "a_hotel"]
    
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        lTopInset = self.view.center.y
        let backroundImage = UIImageView.init(image: UIImage.init(named:nameForBackgroundImage))
        backroundImage.frame = self.view.frame
        self.collectionView?.backgroundView = backroundImage
        
        let nib = UINib(nibName: nibNameMenuCollectionCell, bundle: nil)
        self.collectionView?.registerNib(nib, forCellWithReuseIdentifier: reuseIdentifier)
        
        if let lProfile = Profile.MR_findFirst() {
            self.profile = lProfile as? Profile
        } else {
            
            NetworkManager.sharedInstance.getProfileAndAvertising { (pProfile) in
                self.profile = pProfile
            }
        }

    }

    
    //MARK: UICollectionViewDataSource
    
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return 9
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! MenuCollectionCell
        cell.menuLabel.text =  LocalisationDocument.sharedInstance.getStringWhinName(menuFilesNameArray[indexPath.row])
        cell.menuImageView.image = UIImage(named: menuItemsImgArray[indexPath.row])
        
        return cell
    }
    
    //MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.item {
            case 0:
                showTeeTimeSubView()
            case 1:
                let prosVC = self.storyboard?.instantiateViewControllerWithIdentifier("RestaurantTableViewController")
                self.navigationController?.pushViewController(prosVC!, animated: false)
            case 2:
                let events =  EventsListViewController(nibName: "EventsListController", bundle: nil)
                self.navigationController?.pushViewController(events, animated: false)
            
            case 3:
                let prosVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProShopTableView")
                self.navigationController?.pushViewController(prosVC!, animated: false)

            case 4:
                let coursesVC = self.storyboard?.instantiateViewControllerWithIdentifier(identifierOfListTableController)
                self.navigationController?.pushViewController(coursesVC!, animated: false)
            case 5:
                let prosVC = self.storyboard?.instantiateViewControllerWithIdentifier("ProsListTableViewController")
                self.navigationController?.pushViewController(prosVC!, animated: false)
            case 6:
                showContactSubView()
            case 7:
                let prosVC = self.storyboard?.instantiateViewControllerWithIdentifier("NewsTableViewController")
                self.navigationController?.pushViewController(prosVC!, animated: false)
            case 8:
                let hotelsVC = HotelsTableViewController(nibName: "HotelsTableViewController", bundle: nil)
                self.navigationController?.pushViewController(hotelsVC, animated: false)
            
            
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
    
}
