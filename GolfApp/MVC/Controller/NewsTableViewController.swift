//
//  NewsTableViewController.swift
//  GolfApp
//
//  Created by Admin on 20.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private var newsTableCellIdentifier = "NewsTableCell"

class NewsTableViewController: BaseTableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("nws_nav_bar")
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: newsTableCellIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: newsTableCellIdentifier)
        
        self.tableView.estimatedRowHeight = 1000
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
        cell.nameLabel.text = lNew.title
        cell.subtitleLabel.text = lNew.subtitle
        cell.dateLabel.text = lNew.pubdate
        cell.descriptionLabel.text = lNew.descr
        cell.descriptionLabel.numberOfLines = 1
        for notification in notificationsArray {
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
        
        let cell = tableView.cellForRowAtIndexPath(indexPath) as! NewsTableCell
        
        cell.newNewsImageView.hidden = true
        
        if notificationsArray.count >= indexPath.row + 1 {
        
            let lNotification = notificationsArray[indexPath.row]
            
            Notification.MR_deleteAllMatchingPredicate(NSPredicate(format: "post_type = %@ AND post_id = %@", argumentArray: [lNotification.post_type, lNotification.post_id]))
            
            NSNotificationCenter.defaultCenter().postNotificationName("notificationUnregisterd", object: nil)
            
            notificationsArray.removeAtIndex(indexPath.row)
        }
        
        let vc = NewsDetailController(nibName: "NewsDetailController", bundle: nil)
        
        vc.news = dataSource[indexPath.row] as! New
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    // MARK: - Private methods
    
    func showNewDetailVC() {
        
        let vc = NewsDetailController(nibName: "NewsDetailController", bundle: nil)
        
        vc.news = dataSource.first! as! New
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        refreshControl?.endRefreshing()
        loadedFromDB = true
        dataSource = New.MR_findAllSortedBy("updated_", ascending: false)
        print("DataSource count = \(dataSource.count)")
        tableView.reloadData()
    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getNewsWithPage(pPage, completion: {
            (array, error) in
            
            if self.loadedFromDB {
                self.dataSource = []
                self.loadedFromDB = false
            }
            
            if let lArray = array {
                self.dataSource += lArray
                if lArray.count >= 10 {
                    self.allowLoadMore = true
                    self.allowIncrementPage = true
                    self.addInfiniteScroll()
                    
                } else if self.dataSource.count == 1 {
                    
                    self.showNewDetailVC()
                    
                } else {
                    
                    self.allowLoadMore = false
                    self.tableView.removeInfiniteScroll()
                }
                
             NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                
            } else if error != nil {
                self.allowIncrementPage = false
                self.handleError(error!)
            }
            
            completion()
        })
    }
    
    override func handleReceivedNotifications(array : [Notification]) {
        
    }
    
    
    // MARK: Notifications
    
    override func handleNotification(notification: NSNotification) {
        
        if let notificationBody = notification.userInfo as? [String : AnyObject] {
            
            let lNotification = Notification.notificationWithDictionary(notificationBody)
            
            notificationsArray += [lNotification]
        }
    }
}
