//
//  BaseTableViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/13/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    let dataSource = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        refreshControl!.beginRefreshing()
        self.performSelector(#selector(refresh(_:)), withObject: nil, afterDelay: 5)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func refresh(sender:AnyObject)
    {
        self.tableView.reloadData()
        self.performSelector(#selector(endRefresh), withObject: nil, afterDelay: 0.5)
        
    }
    
    func endRefresh() {
        refreshControl!.endRefreshing()
    }
}
