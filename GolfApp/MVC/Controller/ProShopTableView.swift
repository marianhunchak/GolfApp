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
    
    
    var prosShopArray = [ProsShop]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("ps_list_nav_bar")
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: "CoursTableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
        
        NetworkManager.sharedInstance.getProsShop( { (pProsShop) in
            if  let lProsShopArray = pProsShop {
                self.prosShopArray = lProsShopArray
                self.tableView.reloadData()
            }
        })
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return prosShopArray.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CoursTableCell
        cell.cellInfoLabelHeight.constant = 0
        
        cell.cellItemLabel.text = prosShopArray[indexPath.row].name
        cell.imageForCell = prosShopArray[indexPath.row].images.first
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return view.frame.height / 3
    }
    
    //MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("ProShopDetailViewController") as! ProShopDetailViewController
        
                vc.package_url = prosShopArray[indexPath.row].package_url!
                vc.prosShop = prosShopArray[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
    
}

