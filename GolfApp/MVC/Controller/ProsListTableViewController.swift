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

    var prosArray = [Pros]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_list_nav_bar")
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: parcouseTableCellNibname, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
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
        
        cell.prosLabel.text = (dataSource[indexPath.row] as! Pros).name
        cell.imageForCell = (dataSource[indexPath.row] as! Pros).images.first
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(detailProsControllerIdentfier) as! ProsViewController

        vc.package_url = (dataSource[indexPath.row] as! Pros).package_url!
        vc.pros = (dataSource[indexPath.row] as! Pros)
        
        self.navigationController?.pushViewController(vc, animated: false)
        
    }
    
    // MARK: - Private methods
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        if isRefreshing {
            prosArray = []
            isRefreshing = false
        }
        
        NetworkManager.sharedInstance.getProsWithPage(pPage, completion: {
            (array, error) in
            
            if let lArray = array {
                
                self.dataSource += lArray
                if lArray.count >= 10 {
                    self.allowLoadMore = true
                    self.allowIncrementPage = true
                    self.addInfiniteScroll()
                } else {
                    self.allowLoadMore = false
                    self.tableView.removeInfiniteScroll()
                }
            } else if error != nil {
                self.allowIncrementPage = false
                self.handleError(error!)
            }
            
            completion()
        })
    }
    
}
