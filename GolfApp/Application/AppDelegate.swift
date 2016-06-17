//
//  AppDelegate.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import CoreData
import ReachabilitySwift
import PKHUD
import MagicalRecord

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    var reachability: Reachability?
    var tokenString = ""
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    var advertisemet: Advertisemet?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions:
        [NSObject: AnyObject]?) -> Bool {
        
        UIApplication.sharedApplication().statusBarStyle = .LightContent
        MagicalRecord.setupCoreDataStack()
        
        // Register for remote notifications
        
        let settings: UIUserNotificationSettings =
            UIUserNotificationSettings(forTypes: [.Alert, .Badge, .Sound], categories: nil)
        application.registerUserNotificationSettings(settings)
        application.registerForRemoteNotifications()
        
        // Notify about internet connection
        do {
            reachability = try Reachability.reachabilityForInternetConnection()
        } catch {
            print("Unable to create Reachability")
        }
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector:#selector(reachabilityChanged(_:)),name: ReachabilityChangedNotification,object: reachability)
        
        do{
            try reachability?.startNotifier()
        } catch {
            print("could not start reachability notifier")
        }
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window!.backgroundColor = UIColor.whiteColor()
        // Create a nav/vc pair using the custom ViewController class
        
        let nav = UINavigationController()
        nav.navigationBar.tintColor = UIColor.whiteColor()
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("MainCollectionController") as! MainCollectionController

        // Push the vc onto the nav
        nav.pushViewController(vc, animated: false)
        
        // Set the window’s root view controller
        self.window!.rootViewController = nav
        
        // Present the window
        self.window!.makeKeyAndVisible()
        
        NSNotificationCenter.defaultCenter().postNotificationName("notificationRecieved", object: Notification.MR_findAll(), userInfo: nil)
        Global.getLanguage()
       

        return true
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        dispatch_async(dispatch_get_main_queue()) { 
            if !reachability.isReachable() {
                HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 1.0, completion: nil)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("connected", object: nil)
            }
        }
        
    }

    func applicationDidBecomeActive( application: UIApplication) {
        
        Global.getLanguage()
      
        if reachability!.isReachable() {
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
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(AppDelegate.saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData ) {
        
        // END receive_apns_token
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
//    
        

//        NetworkManager.sharedInstance.removeNotificationsWhithPostID("9534")
//        UIApplication.sharedApplication().applicationIconBadgeNumber = 0

        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print("Device token - " + tokenString)
        print(NSUserDefaults.standardUserDefaults().objectForKey("regid"))
        
//        defaults.setObject(nil, forKey: "language")
        
        Global.getLanguage()
        
        if let storedLanguage = defaults.objectForKey("language") as? String {
            
            if storedLanguage != Global.languageID {
                
                NetworkManager.sharedInstance.registerDeviceWhithToken(tokenString, completion: { (array, error) in
                })
            }
        } else {
            
            NetworkManager.sharedInstance.registerDeviceWhithToken(tokenString, completion: { (array, error) in
            })
        }
        
        
        
           NetworkManager.sharedInstance.unregisterDevice()
    }
    
    // [START receive_apns_token_error]
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
    }
    
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

        NSNotificationCenter.defaultCenter().postNotificationName("notificationRecieved", object: nil, userInfo: userInfo)
        
        print("Notification received: \(userInfo)")
    }
    
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                   fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
        
        if let notificationBody = userInfo as? [String : AnyObject] {
            
            UIApplication.sharedApplication().applicationIconBadgeNumber += 1
            
            let lNotification = Notification.notificationWithDictionary(notificationBody)
            
            NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            
            NSNotificationCenter.defaultCenter().postNotificationName("notificationRecieved", object: lNotification, userInfo: nil)
        }
        

        print("Notification received: \(userInfo)")
        
        
        handler(UIBackgroundFetchResult.NoData);
    }
    
    
    // MARK: Private methods
    
    func showPopUpView() {
        
        let popUpView = PopUpView.loadViewFromNib()
        
        popUpView.frame = CGRectMake(0, 0,
                                     (UIApplication.sharedApplication().keyWindow?.rootViewController!.view.frame.width)!,
                                     (UIApplication.sharedApplication().keyWindow?.rootViewController!.view.frame.height)! )
        
        let lImage  = Image(name: (advertisemet?.name)!, url: (advertisemet?.image)!)
        
        popUpView.websiteUrl = advertisemet?.url
        popUpView.poupImage = lImage
        
        UIApplication.sharedApplication().keyWindow?.rootViewController!.view.addSubview(popUpView)
        UIApplication.sharedApplication().keyWindow?.rootViewController!.view.bringSubviewToFront(popUpView)
        
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
            
        } else {
            print("Date is emty")
            showPopUpView()
        }
    }

    
}


