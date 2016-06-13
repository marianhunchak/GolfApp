//
//  HotelsTableViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/17/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellIdentifier = "parcoursCell"

class HotelsTableViewController: BaseTableViewController {

    var hotelsCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("htl_list_nav_bar")
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: "CoursTableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return dataSource.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CoursTableCell
        cell.cellInfoLabelHeight.constant = 0
        
        let lHotel = dataSource[indexPath.row] as! Hotel
        
        cell.cellItemLabel.text = lHotel.name
        cell.imageForCell = lHotel.images.first

        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height / 3
    }
    
    //MARK: UITableViewDelegate 
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let hotelVC = HotelDetailViewController(nibName: "HotelDetailViewController", bundle: nil)

        hotelVC.hotel = dataSource[indexPath.row] as! Hotel
        self.navigationController?.pushViewController(hotelVC, animated: false)
    }
    
    // MARK: - Private methods
    
    func showHotelsDetailView() {
        
        if self.dataSource.count == 1 {
            let vc =  HotelDetailViewController(nibName: "HotelDetailViewController", bundle: nil)
            
            vc.hotel = dataSource[0] as! Hotel
            vc.hotelsCount = hotelsCount

            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            
            tableView.reloadData()
            
        }
        
    }
    
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = Hotel.MR_findAllSortedBy("createdDate", ascending: true)
        hotelsCount = dataSource.count
        showHotelsDetailView()
        print("DataSource count = \(dataSource.count)")
        tableView.reloadData()
    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getHotelsWithPage(pPage, completion: {
            (array, error) in

            if let lArray = array {
                
                if self.loadedFromDB {
                    self.dataSource = []
                    self.loadedFromDB = false
                }
                
                self.dataSource += lArray
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
            self.showHotelsDetailView()
            completion()
        })
    }

    
}
