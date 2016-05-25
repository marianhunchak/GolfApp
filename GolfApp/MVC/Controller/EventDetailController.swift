//
//  EventDetailController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/24/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let eventDetailCellIdentifier = "eventDetailCell"
private let cellImagereuseIdentifier = "detailImageTableCell"
private let newsCellIndetifire = "NewsDetailCell"
private let detailCellHeight: CGFloat = 465

class EventDetailController: BaseTableViewController {
    
    var event : Event!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("evt_detail_page_nav_bar")
        
        let nib = UINib(nibName: "EventDetailCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: eventDetailCellIdentifier)
        
        let nibFood = UINib.init(nibName: "NewsDetailCell", bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: newsCellIndetifire)
        self.tableView.estimatedRowHeight = 1000

        
    }

    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(newsCellIndetifire, forIndexPath: indexPath) as! NewsDetailCell
            cell.nameLabel.text = event.name
            cell.subtitleLabel.text = event.format
            cell.dateLabel.text = event.event_date
            cell.descriptionNews.text = event.remark1
            if !event.remark2.isEmpty {
                cell.descriptionNews.text.appendContentsOf("\n\(event.remark2)")
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(eventDetailCellIdentifier) as! EventDetailCell
        cell.event = event
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }
        
        return detailCellHeight
    }
    
}
