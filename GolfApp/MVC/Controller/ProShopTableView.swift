//
//  ProShopTableView.swift
//  GolfApp
//
//  Created by Admin on 19.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellIdentifier = "parcoursCell"
private let detailProShopControllerIdentfier = "ProShopDetailViewController"

class ProShopTableView: BaseTableViewController {

    var prosShopCount = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("ps_list_nav_bar")
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
        
        let lProsShop = dataSource[indexPath.row] as! ProsShop
        
        cell.cellItemLabel.text = lProsShop.name
        cell.imageForCell = lProsShop.images.first
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height / 3
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        let vc = ProShopDetailController(nibName: "ProShopDetailController", bundle: nil)
        
        vc.package_url = dataSource[indexPath.row].package_url!
        vc.prosShop = dataSource[indexPath.row] as? ProsShop
        vc.prosShopCount = prosShopCount
        self.navigationController?.pushViewController(vc, animated: false)
       
    }
    // MARK: - Private methods
    
    func showProShopDetailView() {
        
        if self.dataSource.count == 1 {
            let vc =  ProShopDetailController(nibName: "ProShopDetailController", bundle: nil)
            
            vc.prosShop = dataSource[0] as? ProsShop
            vc.prosShopCount = prosShopCount
            vc.package_url = dataSource[0].package_url!
            
            self.navigationController?.pushViewController(vc, animated: false)
        } else {
            
            tableView.reloadData()
            
        }
        
    }
    
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = ProsShop.MR_findAllSortedBy("createdDate", ascending: true)
        prosShopCount = dataSource.count
        print("DataSource count = \(dataSource.count)")
        tableView.reloadData()

    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getProsShop(pPage, completion: {
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
            self.showProShopDetailView()
            completion()
        })
    }
    
    
}

