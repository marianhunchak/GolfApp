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
    
    var connectedToGCM =  false
    var subscribedToTopic = false
    var gcmSenderID: String?
    var registrationToken: String?
    var registrationOptions = [String: AnyObject]()
    
    let registrationKey = "onRegistrationCompleted"
    let messageKey = "onMessageReceived"
    let subscriptionTopic = "/topics/global"
    
    // [START register_for_remote_notifications]
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

        
        return true
    }
    
    func reachabilityChanged(note: NSNotification) {
        
        let reachability = note.object as! Reachability
        
        dispatch_async(dispatch_get_main_queue()) { 
            if !reachability.isReachable() {
                HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 2.0, completion: nil)
            } else {
                NSNotificationCenter.defaultCenter().postNotificationName("connected", object: nil)
            }
        }
        
    }

    func applicationDidBecomeActive( application: UIApplication) {
        
        Global.getLanguage()
    }
    
    func applicationDidEnterBackground(application: UIApplication) {
        
    }
    
    func application( application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken
        deviceToken: NSData ) {
        // [END receive_apns_token]
        let tokenChars = UnsafePointer<CChar>(deviceToken.bytes)
        var tokenString = ""
        
        for i in 0..<deviceToken.length {
            tokenString += String(format: "%02.2hhx", arguments: [tokenChars[i]])
        }
        print(NSUserDefaults.standardUserDefaults().objectForKey("regid"))
        
//        if NSUserDefaults.standardUserDefaults().objectForKey("regid") == nil {
            NetworkManager.sharedInstance.registerDeviceWhithToken(tokenString, completion: { (array, error) in
            })
//        }
        
//           NetworkManager.sharedInstance.unregisterDevice()
    }
    
    // [START receive_apns_token_error]
    func application( application: UIApplication, didFailToRegisterForRemoteNotificationsWithError
        error: NSError ) {
        print("Registration for remote notification failed with error: \(error.localizedDescription)")
        // [END receive_apns_token_error]
        let userInfo = ["error": error.localizedDescription]
        NSNotificationCenter.defaultCenter().postNotificationName(
            registrationKey, object: nil, userInfo: userInfo)
    }
    
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject]) {

//        application.applicationIconBadgeNumber = 0
        
        print("Notification received: \(userInfo)")
    }
    
    func application( application: UIApplication,
                      didReceiveRemoteNotification userInfo: [NSObject : AnyObject],
                                                   fetchCompletionHandler handler: (UIBackgroundFetchResult) -> Void) {
//        let localNotification = UILocalNotification()
//        localNotification.fireDate = NSDate(timeIntervalSinceNow: 0)
//        localNotification.alertBody = "new Blog Posted at iOScreator.com"
//        localNotification.timeZone = NSTimeZone.defaultTimeZone()
//        localNotification.soundName = "default"
//        localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
//        
//        application.scheduleLocalNotification(localNotification)
        
        print("Notification received: \(userInfo)")
        handler(UIBackgroundFetchResult.NoData);
    }
    
}

