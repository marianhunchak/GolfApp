//
//  BaseViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/13/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import MagicalRecord


class BaseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    var notificationsCount = 0
    var backToMainController = false
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        self.configureNavBar()
        
        tableView.backgroundColor = Global.viewsBackgroundColor
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        refresh(refreshControl)
    }
    
    func refresh(sender:AnyObject) {

        self.tableView.reloadData()
        self.performSelector(#selector(endRefresh), withObject: nil, afterDelay: 1)
        
    }
    
    func endRefresh() {
        refreshControl!.endRefreshing()
    }

}


// Extension for configuration navigation bar on all controllers

extension UIViewController {
    
    
    func configureNavBar() {
        self.navigationController?.navigationBar.hidden = false;
        self.navigationController?.navigationBar.barTintColor = Global.navigationBarColor
        
        let homeButton = UIBarButtonItem.init(image:UIImage(named:"a_home_icon"),
                                              style: .Plain,
                                              target: self,
                                              action: #selector(showMainController))
        homeButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.navigationItem.rightBarButtonItem = homeButton
        
        let backButton = UIBarButtonItem.init(image:UIImage(named:"a_back_btn"),
                                              style: .Plain,
                                              target: self,
                                              action: #selector(showPreviousController))

        backButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: self, action: nil)
        negativeSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [negativeSpacer, backButton]
        
        let textAtributes = [ NSFontAttributeName: UIFont(name: "StoneInformal LT Semibold", size: 18)!,
                                                   NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController!.navigationBar.titleTextAttributes = textAtributes
    }
    
    //MARK: Actions
    
    func showMainController() {
        
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func showPreviousController() {
        
        self.navigationController?.popViewControllerAnimated(false)
    }
    
    func removeNotificationsWithsID(sId : NSNumber ,andPostType post_type : String)  {
        
        let lPredicate = NSPredicate(format: "sid = %@ AND post_type = %@", argumentArray: [sId, post_type ])
        
        if let lNotificationsToDelete = Notification.MR_findAllWithPredicate(lPredicate) as? [Notification] {
            
            for notification in lNotificationsToDelete {
            
                UIApplication.sharedApplication().applicationIconBadgeNumber -= 1
                
                if UIApplication.sharedApplication().applicationIconBadgeNumber <= 0 {
                    
                    UIApplication.sharedApplication().applicationIconBadgeNumber = 0
                }
                
//                NetworkManager.sharedInstance.removeNotificationsWhithPostID(notification.post_id.stringValue, sId: notification.sid.stringValue)
                
                
                NetworkManager.sharedInstance.removeNotificationsWhithPostID(notification.post_id.stringValue, sId: notification.sid.stringValue, completion: { (error) in
                    if error != nil {
                    print(error)
                    }
                })
                
                notification.MR_deleteEntity()
                
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                
                NSNotificationCenter.defaultCenter().postNotificationName("notificationUnregisterd", object: post_type)
            }

        }
    }
   
}
