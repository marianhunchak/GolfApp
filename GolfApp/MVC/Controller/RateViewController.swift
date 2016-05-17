//
//  RateViewController.swift
//  GolfApp
//
//  Created by Admin on 15.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellIdetifier = "RateCell"

class RateViewController: BaseViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    var rateArray = [Rate]()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var rateTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
 
        
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        backgroundView.layer.cornerRadius = 5
        rateTableView.layer.cornerRadius = 5
        rateTableView.layer.masksToBounds = true
        self.rateTableView.estimatedSectionHeaderHeight = 30
        self.rateTableView.estimatedRowHeight = 20
        self.rateTableView.separatorColor = Global.navigationBarColor
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("crs_rate_details_nav_bar")
        
        let nib = UINib(nibName: "RateCell", bundle: nil)
        rateTableView.registerNib(nib, forCellReuseIdentifier: cellIdetifier)
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
        cell.frame = CGRect(origin: CGPointZero, size: CGSizeMake(tableView.frame.width, tableView.frame.height))
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
        rates.frame = CGRectMake(0.0, 0.0, tableView.frame.width , tableView.frame.height )
        rates.textLabeForRateHeader.text = rateArray[section].section
        return rates
    }
    

}
