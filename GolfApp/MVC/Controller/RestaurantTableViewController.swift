//
//  RestaurantTableViewController.swift
//  GolfApp
//
//  Created by Admin on 19.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private var reuseIdentifier = "ProsTableCell"
private let parcouseTableCellNibname = "ProsTableCell"
private let detailProsControllerIdentfier = "detailProsControllerIdentfier"

class RestaurantTableViewController: BaseTableViewController {
    
    var restaurantArray = [Restaurant]()
    var restaurantsCount = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("re_list_nav_bar")
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: parcouseTableCellNibname, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        NetworkManager.sharedInstance.getRestaurant { array in
            self.restaurantArray = array!
            self.restaurantsCount = self.restaurantArray.count
            self.showRestaurantDetailView()
        }

        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false;
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.restaurantArray.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProsTableCell
        
        cell.prosLabel.text = restaurantArray[indexPath.row].name
        
        cell.imageForCell = restaurantArray[indexPath.row].images.first
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       let vc =  RestaurantDetailContrller(nibName: "EventsListController", bundle: nil)
        
        vc.restaurant = restaurantArray[indexPath.row]
        vc.restaurantsCount = restaurantsCount
        
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    // MARK: - Private methods
    
    func reloadAllData(sender:AnyObject) {
        
        NetworkManager.sharedInstance.getRestaurant { array in
            self.restaurantArray = array!
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
            
        }
    }
    
    func showRestaurantDetailView() {
    
        if self.restaurantArray.count == 1 {
            let vc =  RestaurantDetailContrller(nibName: "EventsListController", bundle: nil)
            
            vc.restaurant = restaurantArray[0]
            vc.restaurantsCount = restaurantsCount
            
            
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
        
            tableView.reloadData()
        
        }

    }
    
    
}
