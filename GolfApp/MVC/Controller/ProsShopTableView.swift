//
//  ProsShopTableView.swift
//  GolfApp
//
//  Created by Admin on 18.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellIdentifier = "parcoursCell"

class ProsShopTableView: BaseTableViewController {
        
    
//  //  var hotelsArray = [Hotel]()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("htl_list_nav_bar")
//        self.tableView.backgroundColor = Global.viewsBackgroundColor
//        
//        let nib = UINib(nibName: "CoursTableCell", bundle: nil)
//        self.tableView.registerNib(nib, forCellReuseIdentifier: cellIdentifier)
//        
////        NetworkManager.sharedInstance.getHotels( { (pHotels) in
////            if  let lHotelsArray = pHotels {
////                self.hotelsArray = lHotelsArray
////                self.tableView.reloadData()
////            }
////        })
//        
//    }
//    
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//    
//    // MARK: - Table view data source
//    
//    
//    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        
//        return hotelsArray.count
//    }
//    
//    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier, forIndexPath: indexPath) as! CoursTableCell
//        cell.cellInfoLabelHeight.constant = 0
//        
//        cell.cellItemLabel.text = hotelsArray[indexPath.row].name
//        cell.imageForCell = hotelsArray[indexPath.row].images.first
//        
//        return cell
//    }
//    
//    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
//        return view.frame.height / 3
//    }
//    
//    //MARK: UITableViewDelegate
//    
//    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
//        
//        let hotelVC = HotelDetailViewController(nibName: "HotelDetailViewController", bundle: nil)
//        
//        hotelVC.hotel = hotelsArray[indexPath.row]
//        //        hotelVC.facilitiesArray = coursesArray[indexPath.row].facilities
//        //        hotelVC.urlToRate = coursesArray[indexPath.row].rate_url as String
//        
//        self.navigationController?.pushViewController(hotelVC, animated: true)
//    }
//    
//    
//    /*
//     // MARK: - Navigation
//     
//     // In a storyboard-based application, you will often want to do a little preparation before navigation
//     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
//     // Get the new view controller using segue.destinationViewController.
//     // Pass the selected object to the new view controller.
//     }
//     */
    
}
