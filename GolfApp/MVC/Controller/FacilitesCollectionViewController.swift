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
    var timer = NSTimer()
    var timer2 = NSTimer()
    
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(startTimer(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        
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
        
        timer2 = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(FacilitesCollectionViewController.checkDate), userInfo: nil, repeats: true)
        
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
            
            timer = NSTimer.scheduledTimerWithTimeInterval(2, target: self, selector: #selector(FacilitesCollectionViewController.checkDateToShowMaincontroller), userInfo: nil, repeats: true)
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
