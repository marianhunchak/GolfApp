//
//  RateViewController.swift
//  GolfApp
//
//  Created by Admin on 15.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellIdetifier = "RateCell"

class RateViewController: UIViewController , UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    var rateArray = [Rate]()
    var navigationTitle = "crs_rate_details_nav_bar"
    var rateUrl = ""
    var course : Course!
    var restaurant : Restaurant?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        tableView.contentInset = UIEdgeInsets(top: Global.pading,
                                              left: 0,
                                              bottom: Global.pading,
                                              right: 0)


        view.backgroundColor = Global.viewsBackgroundColor
        tableView.layer.cornerRadius = 5
        tableView.layer.masksToBounds = true
        tableView.backgroundColor = Global.viewsBackgroundColor
        tableView.sectionHeaderHeight = 0.0
        tableView.sectionFooterHeight = 0.0
        
        tableView.estimatedSectionHeaderHeight = 30
        tableView.estimatedRowHeight = 20
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName(navigationTitle)
        
        let nib = UINib(nibName: "RateCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: cellIdetifier)
        
        refreshControl = UIRefreshControl()
        refreshControl!.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
        refresh(refreshControl!)
        
        tableView.contentMode = .ScaleToFill
         self.configureNavBar()
//        getData()

        
    }
    
    //MARK: UITableViewDataSource
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        
        return rateArray.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rateKey = rateArray[section]
        
        return rateKey.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdetifier, forIndexPath: indexPath) as! RateCell
        if rateArray.count > 0 {
            
            let lRate = rateArray[indexPath.section]
            
            cell.toursLabel.text = lRate.items[indexPath.row].descr
            cell.priceLabel.text = lRate.items[indexPath.row].price
            cell.priceLabel.sizeToFit()
            
        }
        
        return cell
    }
    
    //MARK: Size
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let rates = ViewForRateHeader.loadViewFromNib()
        rates.textLabeForRateHeader.text = rateArray[section].section
        return rates
    }
    
    //  MARK: Private methods
    
    func loadDataFromDB()  {
        if navigationTitle == "re_menu_nav_bar" {

            if let lRestaurantMenu = RestaurantMenu.MR_findFirstByAttribute("menuId", withValue: restaurant!.id) as? RestaurantMenu {
                self.rateArray = lRestaurantMenu.menuList
                self.tableView.reloadData()
            }
            
        } else if navigationTitle == "crs_rate_details_nav_bar" {

            if let lCourseRate = CourseRate.MR_findFirstByAttribute("courseId", withValue: course.id) as? CourseRate {
                self.rateArray = lCourseRate.ratesList
                self.tableView.reloadData()
            }

        }
    }
    
    func loadDataFromServer() {
        
        if navigationTitle == "re_menu_nav_bar" {
            NetworkManager.sharedInstance.getMenu(urlToRate: rateUrl) { array , error in
                
                if let lArray = array {
                    self.rateArray = lArray
                    self.tableView.reloadData()
                    
                    RestaurantMenu.MR_truncateAll()
                    
                    let lRestaurantMenu = RestaurantMenu.MR_createEntity() as! RestaurantMenu
                    lRestaurantMenu.menuId = self.restaurant!.id
                    lRestaurantMenu.menuList = array
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                }
                self.refreshControl?.endRefreshing()
            }
        } else if navigationTitle == "crs_rate_details_nav_bar" {
            
            NetworkManager.sharedInstance.getRate(urlToRate: course.rate_url) { array, error in
                
                if let lArray = array {
                    self.rateArray = lArray
                    self.tableView.reloadData()
                    
                    CourseRate.MR_truncateAll()
                    
                    let lCourseRate = CourseRate.MR_createEntity() as! CourseRate
                    lCourseRate.courseId = self.course.id
                    lCourseRate.ratesList = array
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                }
                
                self.refreshControl?.endRefreshing()
            }
            
        }
        
    }
    
    func refresh(sender: AnyObject) {
        
        loadDataFromDB()
        
        if rateArray.isEmpty {
            refreshControl?.beginRefreshing()
        }
        
        loadDataFromServer()
    }
    
}
