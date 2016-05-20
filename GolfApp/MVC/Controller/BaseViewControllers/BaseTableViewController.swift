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
//        tableView.addSubview(refreshControl!)
        refreshControl!.beginRefreshing()
        self.performSelector(#selector(refresh(_:)), withObject: nil, afterDelay: 5)
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func refresh(sender:AnyObject)
    {
        // Updating your data here...
        
        self.tableView.reloadData()
        self.performSelector(#selector(endRefresh), withObject: nil, afterDelay: 1)
        
    }
    
    func endRefresh() {
        refreshControl!.endRefreshing()
    }
}
