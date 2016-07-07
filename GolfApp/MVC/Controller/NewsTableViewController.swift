//
//  NewsTableViewController.swift
//  GolfApp
//
//  Created by Admin on 20.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import ReachabilitySwift
import PKHUD
import CoreData

private var newsTableCellIdentifier = "NewsTableCell"

class NewsTableViewController: BaseTableViewController {
    
    var newsCount = 1
    var fetchResultController : NSFetchedResultsController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("nws_nav_bar")
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: newsTableCellIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: newsTableCellIdentifier)
        
        self.tableView.estimatedRowHeight = 1000
        
        notificationsArray = Notification.MR_findAll() as! [Notification]
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false;
        handleReceivedNotifications(notificationsArray)
        
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableCell", forIndexPath: indexPath) as! NewsTableCell
        
        
        let lNew = dataSource[indexPath.row] as! New
        
        let dateString:String = lNew.pubdate
        let dateFormat = NSDateFormatter.init()
        dateFormat.dateStyle = .FullStyle
        dateFormat.dateFormat = "yyyy-MM-dd"
        
        let dateFormat2 = NSDateFormatter.init()
        dateFormat2.dateStyle = .FullStyle
        dateFormat2.dateFormat = "dd-MM-yyyy"
        
        let date:NSDate? = dateFormat.dateFromString(dateString)
        let stringOfDateInNewFornat = dateFormat2.stringFromDate(date!)

        cell.nameLabel.text = lNew.title
        cell.subtitleLabel.text = lNew.subtitle
        cell.dateLabel.text = stringOfDateInNewFornat
        cell.descriptionLabel.text = lNew.descr
        cell.descriptionLabel.numberOfLines = 1
        
        let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@", argumentArray: [ NSNumber(integer: Int(Global.languageID)!), "news" ])
        
        for notification in Notification.MR_findAllWithPredicate(lPredicate) as! [Notification] {
            if  let i = (dataSource as! [New]).indexOf({$0.id == notification.post_id}) {
                
                if indexPath.row == i {
                    
                    cell.displayNewNewsImage = true
                }
            }
        }
        return cell
    }
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     
        return UITableViewAutomaticDimension

    }
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if appDelegate.reachability?.isReachable() == true {
            let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewsTableCell
            
            cell.newNewsImageView.hidden = true
            
            if dataSource.count >= indexPath.row + 1 {
                
                let lNew = dataSource[indexPath.row] as! New
                
                let lPredicate = NSPredicate(format: "post_type = %@ AND post_id = %@", argumentArray: ["news", lNew.id])
                
                if let lNotificationToDelete = Notification.MR_findFirstWithPredicate(lPredicate) as? Notification {
                    
                    if UIApplication.sharedApplication().applicationIconBadgeNumber > 0 {
                        
                        UIApplication.sharedApplication().applicationIconBadgeNumber -= 1
                    }
                    
                    //                NetworkManager.sharedInstance.removeNotificationsWhithPostID(lNotificationToDelete.post_id.stringValue,
                    //                                                                             sId: lNotificationToDelete.sid.stringValue)
                    
                    NetworkManager.sharedInstance.removeNotificationsWhithPostID(lNotificationToDelete.post_id.stringValue, sId: lNotificationToDelete.sid.stringValue, completion: { (error) in
                        if error != nil {
                            print(error)
                        }
                    })
                    
                    lNotificationToDelete.MR_deleteEntity()
                    
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    
                    NSNotificationCenter.defaultCenter().postNotificationName("notificationUnregisterd", object: "news")
                    
                    notificationsArray = Notification.MR_findAll() as! [Notification]
                    
                    tableView.reloadData()
                }
            }
            
            let vc = NewsDetailController(nibName: "NewsDetailController", bundle: nil)
            
            vc.news = dataSource[indexPath.row] as! New
            vc.newsCount = newsCount
            
            self.navigationController?.pushViewController(vc, animated: false)

        } else {
            HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 1.0, completion: nil)
            
        }
        

        
    }
    
    // MARK: - Private methods
    
    func showNewDetailVC() {
        
        let vc = NewsDetailController(nibName: "NewsDetailController", bundle: nil)
        
        vc.news = dataSource.first! as! New
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // MARK: - Private methods
    
    func showNewsDetailView() {
        
        if self.dataSource.count == 1 {
            let vc =  NewsDetailController(nibName: "NewsDetailController", bundle: nil)
            
            vc.news = dataSource[0] as? New
            vc.newsCount = newsCount
            
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            
            tableView.reloadData()
            
        }
        
    }
    
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        
            refreshControl?.endRefreshing()
            loadedFromDB = true
            dataSource = New.MR_findAllSortedBy("updated_", ascending: false)
            newsCount = dataSource.count
            self.showNewsDetailView()
            print("DataSource count = \(dataSource.count)")
            tableView.reloadData()
    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getNewsWithPage(pPage, completion: {
            (array, error) in
            
            if let lArray = array {
               
                
                if pPage == 1 {
                    
                    if self.loadedFromDB == true {
                        self.loadedFromDB = false
                        self.dataSource = []
                    }
                    
                }

                self.dataSource += lArray
                self.newsCount = self.dataSource.count
                if lArray.count >= 10 {
                    
                    self.allowLoadMore = true
                    self.allowIncrementPage = true
                    self.addInfiniteScroll()
                    
                } else if self.dataSource.count == 1 {
                    
                    self.showNewDetailVC()
                    
                } else {
                    
                    self.allowLoadMore = false
                    self.tableView.removeInfiniteScroll()
                  //  self.tableView.reloadData()
                }
               // self.tableView.reloadData()
                
            } else if error != nil {
                self.allowIncrementPage = false
                self.handleError(error!)

            }
           
            
            self.showNewsDetailView()
            completion()
            
        })
        
    }
    
    override func handleReceivedNotifications(array : [Notification]) {
        
    }

    // MARK: Notifications
    
    override func handleNotification(notification: NSNotification) {
        
        let lNotification = notification.object as! Notification

        if lNotification.post_type == "news" {
            notificationsArray += [lNotification]
            
            refresh(refreshControl!)
        }
    }
    

    
}
