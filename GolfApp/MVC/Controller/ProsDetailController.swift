//
//  ProsViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/16/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "detailImageTableCell"
private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailImageTableCellNibName = "DetailmageTableCell"
private let detailDescriptionCellNibName = "DetailInfoCell"
private let segueIdetifireToSwipeCourseController = "showSwipeCourseController"

class ProsDetailController: BaseTableViewController, ProHeaderDelegate {
    
    var pros = Pros()
    var package_url = String()
    let headerView = ViewForProHeader.loadViewFromNib()
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.setupHeaderView()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_detail_nav_bar")
        tableView.estimatedRowHeight = 80;
        tableView.backgroundColor = Global.viewsBackgroundColor
        tableView.contentInset = UIEdgeInsets(top: tableView.contentInset.top + Global.headerHeight,
                                              left: 0,
                                              bottom: Global.pading,
                                              right: 0)
        
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        
        headerView.removeFromSuperview()
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let lCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
            lCell.imagesArray = pros.images

            return lCell
        }

        let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
        cell2.nameLabel.text = pros.name
        cell2.detailLabelHeight.constant = 0
        cell2.descriptionLabel.text = pros.descr

        return cell2

    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK: Private methods
    
    func setupHeaderView() {
        
        headerView.frame = CGRectMake(0.0,
                                      (self.navigationController?.navigationBar.frame.maxY)!,
                                      Global.displayWidth,
                                      Global.headerHeight)
        
        self.navigationController?.view.addSubview(headerView)
        self.navigationController?.view.bringSubviewToFront((self.navigationController?.navigationBar)!)
        
        headerView.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("pro_contact_btn"), forState: .Normal)
        headerView.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("pro_rate_offer_btn"), forState: .Normal)
        
        headerView.button1.setButtonEnabled(true)
        headerView.button2.setButtonEnabled(pros.package_count > 0 ? true : false)
        
        headerView.delegate = self
    }
    
    func pressedButton1(tableProHeader: ViewForProHeader, button1Pressed button1: AnyObject) {
        showContactSubView()
    }
    
    func pressedButton2(tableCourseHeader: ViewForProHeader, button2Pressed button2: AnyObject) {
        
        let packageVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewControllerWithIdentifier("OffersViewController") as! OffersViewController
        packageVC.packageUrl = pros.package_url
        packageVC.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_rate_offer_nav_bar")
        self.navigationController?.pushViewController(packageVC, animated: false)
        
    }

    func showContactSubView() {
        
        let teeTime = TeeTimeView.loadViewFromNib()
        teeTime.title.text = LocalisationDocument.sharedInstance.getStringWhinName("pro_contact_pop_up_title")
        teeTime.emailString = pros.email
        teeTime.phoneString = pros.phone
        teeTime.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.navigationController?.view.addSubview(teeTime)
        teeTime.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            teeTime.alpha = 1
        }
    }
    
}
