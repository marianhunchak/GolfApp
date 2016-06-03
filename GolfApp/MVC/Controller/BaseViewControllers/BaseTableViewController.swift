//
//  BaseTableViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/13/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import PKHUD
import MagicalRecord

class BaseTableViewController: UITableViewController {

    var dataSource = [AnyObject]()
    var allowLoadMore = false
    var isRefreshing = false
    var allowIncrementPage = false
    var loadedFromDB = true
    let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top,
                                              left: 0,
                                              bottom: Global.pading,
                                              right: 0)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl!.beginRefreshing()
        refresh(refreshControl!)
        
        tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
        tableView.infiniteScrollIndicatorMargin = 30
        
//        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(handleInetNotification(_:)), name: "connected", object: nil)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    //MARK: Private methods
    
    func refresh(sender: AnyObject) {
        
        loadDataFromDB()
        
        if let reachability  = appDelegate.reachability {
            if !reachability.isReachable() {
                HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 1.0, completion: nil)
                self.refreshControl!.endRefreshing()
                return
            }
        }
        
        isRefreshing = true
        allowLoadMore = false
//        dataSource = []
        
        if dataSource.isEmpty {
            self.refreshControl!.beginRefreshing()
        }
        
        loadDataWithPage(getPage()) {
            self.isRefreshing = false
            self.tableView.reloadData()
            self.refreshControl!.endRefreshing()
        }
        
    }
    
    func loadDataFromDB() {
        
    }
    
    func loadDataWithPage(pPage : Int, completion : (Void) -> Void) {
        
        completion()
    }
    
    func getPage() -> Int {
        
        struct Temp { static var page = 1 }
        
        if allowLoadMore && allowIncrementPage {
            Temp.page += 1
        } else if isRefreshing {
            Temp.page = 1
        }
        print("page = \(Temp.page)")
        
        return Temp.page
    }
    
    func addInfiniteScroll() {
        
        if !(tableView.infiniteScrollIndicatorView is CustomInfiniteIndicator) {
            tableView.infiniteScrollIndicatorView = CustomInfiniteIndicator(frame: CGRectMake(0, 0, 24, 24))
            tableView.infiniteScrollIndicatorMargin = 30
        }
        
        
        tableView.addInfiniteScrollWithHandler { [weak self] (scrollView) -> Void in
            let tableView = scrollView as! UITableView
            
            if self!.allowLoadMore {
                self!.loadDataWithPage(self!.getPage()) {
                    tableView.reloadData()
                    tableView.finishInfiniteScroll()
                }
            } else {
                tableView.finishInfiniteScroll()
            }
        }
    }
    
    func handleError(error : NSError) {
        
        let response = error.userInfo["com.alamofire.serialization.response.error.response"]
        
        if response?.statusCode == nil {
            HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 2.0, completion: nil)
        } else {
            HUD.flash(.LabeledError(title: LocalisationDocument.sharedInstance.getStringWhinName("no_api"), subtitle: nil), delay: 2.0)
        }
    }
    //MARK: Notifications 
    
    func handleInetNotification(sender : NSNotification) {
        if dataSource.isEmpty {
            refresh(refreshControl!)
        }
    }
}
