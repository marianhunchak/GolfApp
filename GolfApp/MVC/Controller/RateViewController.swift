//
//  RateViewController.swift
//  GolfApp
//
//  Created by Admin on 15.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellIdetifire = "RateCell"

class RateViewController: UIViewController ,UITableViewDelegate ,UITableViewDataSource {
    
    var rateArray = [Rate]()
    
    @IBOutlet weak var rateTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        print(rateArray)
        rateTableView.layer.cornerRadius = 5
        self.rateTableView.estimatedSectionHeaderHeight = 30
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
  
        return rateArray.count
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let rateKey = rateArray[section]

        return rateKey.items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdetifire, forIndexPath: indexPath) as! RateCell
        
        if rateArray.count > 0 {
            
            let lRate = rateArray[indexPath.section]

            cell.toursLabel.text = lRate.items[indexPath.row].descr
            cell.priceLabel.text = lRate.items[indexPath.row].price
            }
 
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {

        
        return UITableViewAutomaticDimension
        
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
 func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let rates : ViewForRateHeader = ViewForRateHeader.loadViewFromNib()
        rates.center = self.view.center
        rates.frame = CGRectMake(0.0, 0.0, tableView.frame.width , tableView.frame.height )
        rates.textLabeForRateHeader.text = rateArray[section].section
        return rates
    }
    

}
