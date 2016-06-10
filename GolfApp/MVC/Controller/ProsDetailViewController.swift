//
//  ProsDetailViewController.swift
//  GolfApp
//
//  Created by Admin on 10.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "detailImageTableCell"
private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailImageTableCellNibName = "DetailmageTableCell"
private let detailDescriptionCellNibName = "DetailInfoCell"
private let segueIdetifireToSwipeCourseController = "showSwipeCourseController"


class ProsDetailViewController: BaseViewController , ProHeaderDelegate , UITableViewDelegate, UITableViewDataSource {
    
    var pros: Pros!
    var package_url = String()
    @IBOutlet weak var viewForHeader: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.viewForHeader.backgroundColor = Global.viewsBackgroundColor
        
        navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_detail_nav_bar")
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        self.tableView.estimatedRowHeight = 1000
        
        setupHeaderView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
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
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK: Private methods
    
    func setupHeaderView() {
        let headerView = ViewForProHeader.loadViewFromNib()
        headerView.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, viewForHeader.frame.size.height)
        viewForHeader.addSubview(headerView)
        
        headerView.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("pro_contact_btn"), forState: .Normal)
        headerView.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("pro_rate_offer_btn"), forState: .Normal)
        
        headerView.button1.setButtonEnabled(true)
        headerView.button2.setButtonEnabled(pros.package_count?.intValue > 0 ? true : false)
        
        headerView.delegate = self
    }
    
    func pressedButton1(tableProHeader: ViewForProHeader, button1Pressed button1: AnyObject) {
        showContactSubView()
    }
    
    func pressedButton2(tableCourseHeader: ViewForProHeader, button2Pressed button2: AnyObject) {

        let packageVC = OffersController(nibName: "OffersController", bundle: nil)
        packageVC.packageUrl = pros.package_url
        packageVC.titleOfferts = "pro_rate_offer_nav_bar"
        packageVC.offertsArray = pros.packagesList
        packageVC.pros = pros
        
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
