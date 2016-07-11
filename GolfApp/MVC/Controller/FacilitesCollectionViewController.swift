//
//  FacilitesCollectionViewController.swift
//  GolfApp
//
//  Created by Admin on 13.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private var nibNameFacilitesCollectionCell = "FacilitesCollectionCell"
private var facilitesCollectionCellIdentifier = "FacilitesCollectionCell"

class FacilitesCollectionViewController: UIViewController , UICollectionViewDelegate ,UICollectionViewDataSource
 {
    
    var facilitesItemsImgOnArray = ["facilites_club_house_", "facilites_practice_",   "facilites_pitching_",
                                  "facilites_putting_" ,     "facilites_buggy_",      "facilites_club_hire_",
                                  "facilites_proshop_",      "facilites_pro_",        "facilites_changing_room_",
                                  "facilites_wifi_" ,        "facilites_restaurant_", "facilites_hotel_on_site_",
                                  "facilites_poll_" ,        "facilites_tennis_",     "facilites_parking_"]
 
    
    var facilitesItemNameArray = ["Club house" , "Practice",    "Pitching",
                                  "Putting" ,    "Buggy",       "Club Hire",
                                  "Proshop" ,    "Pros" ,       "Shower"  ,
                                  "Wi-fi",       "Restaurant",  "Hotel" ,
                                  "Pool",        "Tennis",      "Parking"]
    
    var facilitiesLocalisNames = ["crs_club_house_icon", "crs_practice_icon",   "crs_pitching_icon",
                                  "crs_putting_icon",    "crs_buggy_icon",      "crs_club_hire_icon",
                                  "crs_proshop_icon",    "crs_pros_icon",       "crs_shower_icon",
                                  "crs_wifi_icon",       "crs_restaurant_icon", "crs_hotel_icon",
                                  "crs_pool_icon",       "crs_tennis_icon",     "crs_parking_icon"]
                                  
                                  
    
    var facilites = [String]()
    
    var lTopInset : CGFloat?
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    
    @IBOutlet weak var facilitesCollectonView: UICollectionView!
    @IBOutlet weak var backgroundCollectionView: UIView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.configureNavBar()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("crs_facilities_details_nav_bar")
        backgroundCollectionView.layer.cornerRadius = 5
        
        let nib = UINib(nibName: nibNameFacilitesCollectionCell, bundle: nil)
        self.facilitesCollectonView?.registerNib(nib, forCellWithReuseIdentifier: facilitesCollectionCellIdentifier)
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        checkInternet()
    }

    //MARK:UICollectionViewDataSource
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return facilitesItemNameArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(facilitesCollectionCellIdentifier, forIndexPath: indexPath) as! FacilitesCollectionCell
        var imgName = facilitesItemsImgOnArray[indexPath.row]
        
        if self.facilites.contains(facilitesItemNameArray[indexPath.row]) {
            
            imgName += "on"
        } else {
            imgName += "off"
        }
        cell.facilitesCellImage.image = UIImage(named: imgName)
        let name = facilitiesLocalisNames[indexPath.row]
        cell.facilitesCellLabel.text = LocalisationDocument.sharedInstance.getStringWhinName(name)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        
        let lCellWidth:CGFloat = self.view.frame.width / 3.0 - 32.0
        let lcellHeigt:CGFloat = (self.view.frame.height) / 5.0 - 30
        
        return CGSize(width: lCellWidth, height: lcellHeigt)
    }
    
    func collectionView(collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        
        return UIEdgeInsets(top: -50.0, left: 20.0, bottom: 0.0, right: 20.0)
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
