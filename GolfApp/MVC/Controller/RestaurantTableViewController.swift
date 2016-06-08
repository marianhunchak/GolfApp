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
    
    //var restaurantArray = [Restaurant]()
    var restaurantsCount = 1
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("re_list_nav_bar")
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: parcouseTableCellNibname, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
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
        
        return self.dataSource.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProsTableCell
        
        let lRestaurant = dataSource[indexPath.row] as! Restaurant
        
        cell.prosLabel.text = lRestaurant.name
        
        cell.imageForCell = lRestaurant.images.first
        
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
       let vc =  RestaurantDetailContrller(nibName: "EventsListController", bundle: nil)
        
        vc.restaurant = dataSource[indexPath.row] as? Restaurant
        vc.restaurantsCount = restaurantsCount
        vc.package_url = dataSource[indexPath.row].package_url!
        
        self.navigationController?.pushViewController(vc, animated: false)

    }
    
    // MARK: - Private methods

    func showRestaurantDetailView() {
    
        if self.dataSource.count == 1 {
            let vc =  RestaurantDetailContrller(nibName: "EventsListController", bundle: nil)
            
            vc.restaurant = dataSource[0] as? Restaurant
            vc.restaurantsCount = restaurantsCount
            vc.package_url = dataSource[0].package_url!
            
            
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
        
            tableView.reloadData()
        
        }

    }
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = Restaurant.MR_findAllSortedBy("createdDate", ascending: true)
        restaurantsCount = dataSource.count
        self.showRestaurantDetailView()
        print("DataSource count = \(dataSource.count)")
        tableView.reloadData()
    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getRestaurant(pPage, completion: {
            (array, error) in
            
            if self.loadedFromDB {
                self.dataSource = []
                self.loadedFromDB = false
            }
            
            if let lArray = array {
                
                self.dataSource += lArray
                self.restaurantsCount = lArray.count
                if lArray.count >= 10 {
                    self.allowLoadMore = true
                    self.allowIncrementPage = true
                    self.addInfiniteScroll()
                } else {
                    self.allowLoadMore = false
                    self.tableView.removeInfiniteScroll()
                }
                
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                
            } else if error != nil {
                self.allowIncrementPage = false
                self.handleError(error!)
            }
            self.showRestaurantDetailView()
            completion()
        })
    }
    
    
}
