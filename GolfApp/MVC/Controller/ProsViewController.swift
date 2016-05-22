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

class ProsViewController: BaseViewController, ProHeaderDelegate,UITableViewDelegate, UITableViewDataSource {
    
    var proArray = [Package]()
    var pros = Pros()
    var package_url = String()
    let viewForHead = ViewForProHeader.loadViewFromNib()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var prosTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupHeaderView()
        
        NetworkManager.sharedInstance.getPackages(urlToPackage: package_url) { array in
            self.proArray = array!
        }
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_detail_nav_bar")
        
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        prosTableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        prosTableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
        self.prosTableView.estimatedRowHeight = 80;
        prosTableView.backgroundColor = Global.viewsBackgroundColor

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
            
        else if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
            cell2.nameLabel.text = pros.name
            cell2.detailLabelHeight.constant = 0
            cell2.descriptionLabel.text = pros.descr
         

            return cell2
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
        cell.imagesArray = pros.images
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
        viewForHead.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width , headerView.frame.size.height)
        headerView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_contact_btn"), forState: .Normal)
        viewForHead.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_special_offer_nav_bar"), forState: .Normal)
        
        viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
        viewForHead.setButtonEnabled(viewForHead.button2, enabled: pros.package_count > 0 ? true : false)

        viewForHead.delegate = self
    }
    func pressedButton2(tableCourseHeader: ViewForProHeader, button2Pressed button2: AnyObject) {
       
        let packageVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewControllerWithIdentifier("OffersViewController") as! OffersViewController
        packageVC.packageUrl = pros.package_url
        packageVC.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_rate_offer_nav_bar")
        self.navigationController?.pushViewController(packageVC, animated: true)
        
    }
    
    func pressedButton1(tableProHeader: ViewForProHeader, button1Pressed button1: AnyObject) {
        showContactSubView()
    }
    
    func showContactSubView() {
        
        let teeTime = TeeTimeView.loadViewFromNib()
        teeTime.title.text = LocalisationDocument.sharedInstance.getStringWhinName("pro_contact_pop_up_title")
        teeTime.emailString = pros.email
        teeTime.phoneString = pros.phone
        teeTime.frame = CGRectMake(0, 0, self.view.frame.width , self.view.frame.height )
        self.view.addSubview(teeTime)
        teeTime.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            teeTime.alpha = 1
        }
    }

}
