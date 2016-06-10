//
//  ProShopDetailController.swift
//  GolfApp
//
//  Created by Admin on 09.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
private let reuseIdentifier = "detailImageTableCell"
private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailImageTableCellNibName = "DetailmageTableCell"
private let detailDescriptionCellNibName = "DetailInfoCell"
private let segueIdetifireToSwipeCourseController = "showSwipeCourseController"

class ProShopDetailController: BaseViewController , ProHeaderDelegate ,UITableViewDelegate ,UITableViewDataSource{

    var proArray = [Package]()
    var prosShop : ProsShop?
    var package_url = String()
    
    
    
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.headerView.backgroundColor = Global.viewsBackgroundColor

        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("ps_detail_nav_bar")
        
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
        self.tableView.estimatedRowHeight = 80;
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        self.setupHeaderView()
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
            lCell.imagesArray = prosShop!.images
            
            return lCell
        }
            
        else if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
            cell2.nameLabel.text = prosShop!.name
            cell2.detailLabelHeight.constant = 0
            cell2.descriptionLabel.text = prosShop!.descr
            
            return cell2
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
        cell.imagesArray = prosShop!.images
        return cell
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
        let viewForHead = ViewForProHeader.loadViewFromNib()
        viewForHead.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, headerView.frame.size.height)
        headerView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_contact_btn"), forState: .Normal)
        viewForHead.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_special_offer_nav_bar"), forState: .Normal)
        
        viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
        viewForHead.setButtonEnabled(viewForHead.button2, enabled: prosShop!.package_count!.intValue > 0 ? true : false)
        
        viewForHead.delegate = self
    }
    func pressedButton2(tableCourseHeader: ViewForProHeader, button2Pressed button2: AnyObject) {

        
        let packageVC = OffersController(nibName: "OffersController", bundle: nil)
        packageVC.packageUrl = prosShop!.package_url
        packageVC.titleOfferts = "ps_special_offer_nav_bar"
        packageVC.offertsArray = prosShop?.packagesList
        packageVC.prosShop = prosShop
        
        self.navigationController?.pushViewController(packageVC, animated: false)
        
    }
    
    func pressedButton1(tableProHeader: ViewForProHeader, button1Pressed button1: AnyObject) {
        showContactSubView()
    }
    
    func showContactSubView() {
        
        let teeTime = TeeTimeView.loadViewFromNib()
        teeTime.title.text = LocalisationDocument.sharedInstance.getStringWhinName("pro_contact_pop_up_title")
        teeTime.emailString = prosShop!.email
        teeTime.phoneString = prosShop!.phone
        teeTime.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(teeTime)
        teeTime.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            teeTime.alpha = 1
        }
    }
}