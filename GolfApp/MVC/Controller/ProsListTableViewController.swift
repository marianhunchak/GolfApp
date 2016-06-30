//
//  ProsListTableViewController.swift
//  GolfApp
//
//  Created by Admin on 19.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private var reuseIdentifier = "ProsTableCell"
private let parcouseTableCellNibname = "ProsTableCell"
private let detailProsControllerIdentfier = "detailProsControllerIdentfier"

class ProsListTableViewController: BaseTableViewController {
    
    var prosCount = 1

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_list_nav_bar")
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: parcouseTableCellNibname, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        notificationsArray = Notification.MR_findAll() as! [Notification]
        
        NSNotificationCenter.defaultCenter().addObserver(self,
                                                         selector: #selector(handleUnregisteringNotification(_:)),
                                                         name: "notificationUnregisterd",
                                                         object: nil)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProsTableCell
        cell.badgeLabel.text = nil
        cell.badgeLabel.hidden = true

        let lPros = dataSource[indexPath.row] as! Pros
        cell.prosLabel.text = lPros.name
        cell.imageForCell = lPros.images.first
        
        let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND sid = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "pros", lPros.id!])
        
        let lNotifications = Notification.MR_findAllWithPredicate(lPredicate) as! [Notification]
        
        if lNotifications.count > 0 {
            cell.badgeLabel.hidden = false
            cell.badgeLabel.text = "\(lNotifications.count)"
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    // MARK: - UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let vc =  ProsDetailViewController(nibName: "ProsDetailViewController", bundle: nil)
    
        vc.package_url = (dataSource[indexPath.row] as! Pros).package_url!
        vc.pros = dataSource[indexPath.row] as! Pros
        vc.prosCount = prosCount
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    // MARK: - Private methods
    
    func showProsDetailView() {
        
        if self.dataSource.count == 1 {
            let vc =  ProsDetailViewController(nibName: "ProsDetailViewController", bundle: nil)
            
            vc.pros = dataSource[0] as? Pros
            vc.prosCount = prosCount
            vc.package_url = dataSource[0].package_url!
            
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            
            tableView.reloadData()
            
        }
        
    }

    
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = Pros.MR_findAll()
        prosCount = dataSource.count
        print("DataSource count = \(dataSource.count)")
        tableView.reloadData()
    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getProsWithPage(pPage, completion: {
            (array, error) in

            if let lArray = array {
                
                if pPage == 1 {
                    
                    if self.loadedFromDB {
                        self.dataSource = []
                        self.loadedFromDB = false
                    }
                    
                }

              self.dataSource += lArray
              self.prosCount = lArray.count  
                if lArray.count >= 10 {
                    self.allowLoadMore = true
                    self.allowIncrementPage = true
                    self.addInfiniteScroll()
                    self.tableView.reloadData()
                } else {
                    self.allowLoadMore = false
                    self.tableView.removeInfiniteScroll()
                }
            } else if error != nil {
                self.allowIncrementPage = false
                self.handleError(error!)
            }
            self.showProsDetailView()
            completion()
        })
    }
    

    
    // MARK: Notifications
    
    override func handleReceivedNotifications(array : [Notification]) {
        
    }
    
    override func handleNotification(notification: NSNotification) {
        
        if let notificationBody = notification.userInfo as? [String : AnyObject] {
            
            let lNotification = Notification.notificationWithDictionary(notificationBody)
            
            notificationsArray += [lNotification]
        }
    }
    
    func handleUnregisteringNotification(notification : NSNotification) {
        
       tableView.reloadData()
    }
    
}
