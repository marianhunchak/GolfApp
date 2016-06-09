//
//  RestaurantDetailViewContrller.swift
//  GolfApp
//
//  Created by Admin on 09.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellImagereuseIdentifier = "detailImageTableCell"
private let courseFooterIndetifire = "courseFooterIndetifire"

class RestaurantDetailViewContrller: BaseViewController ,CourseHeaderDelegate , UITableViewDelegate, UITableViewDataSource {
    
    
    var restaurant : Restaurant?
    var restaurantsCount = 1
    var package_url = String()
    let viewForHeader = ViewForDetailHeader.loadViewFromNib()
    
     @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("re_detail_nav_bar")
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.headerView.backgroundColor = Global.viewsBackgroundColor
        
        
        let nib = UINib.init(nibName: "DetailmageTableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellImagereuseIdentifier)
        
        let nibFood = UINib.init(nibName: "DetailInfoCell", bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        self.tableView.estimatedRowHeight = 1000
        
        self.setupHeaderView()
        
    }
    

    
     func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
     func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
            cell2.detailLabelHeight.constant = 0
            cell2.nameLabel.text = restaurant!.name
            cell2.descriptionLabel.text = restaurant!.descr
            
            return cell2
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellImagereuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
        cell.imagesArray = self.restaurant!.images
        print(refresh)
        return cell
    }
    
    
    //MARK: Private methods
    func setupHeaderView() {
       
        viewForHeader.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, headerView.frame.size.height)
        self.view.addSubview(viewForHeader)
        
        viewForHeader.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("re_contact_btn"), forState: .Normal)
        viewForHeader.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("re_menu_btn"), forState: .Normal)
        viewForHeader.button3.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("re_suggestion_btn"), forState: .Normal)
        
        
        self.viewForHeader.setButtonEnabled(self.viewForHeader.button1, enabled: true)
        self.viewForHeader.setButtonEnabled(self.viewForHeader.button2, enabled: true)
        self.viewForHeader.setButtonEnabled(self.viewForHeader.button3, enabled: true)
        
         viewForHeader.delegate = self
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK: CourseHeaderDelegate
    
    func tableCourseHeader(tableCourseHeader: ViewForDetailHeader, button1Pressed button1: AnyObject) {
        
        let contact = ContactView.loadViewFromNib()
        contact.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!,
                                   (UIApplication.sharedApplication().keyWindow?.frame.size.height)!)
        
        self.navigationController!.view.addSubview(contact)
        contact.phoneString = restaurant!.phone
        contact.emailString = restaurant!.email
        contact.longitude = restaurant!.longitude
        contact.latitude = restaurant!.latitude
        contact.alpha = 0
        UIView.animateWithDuration(0.25) { () -> Void in
            contact.alpha = 1
        }
    }
    
    func pressedButton2(tableCourseHeader: ViewForDetailHeader, button2Pressed button2: AnyObject) {
        
        let menuVC = RateViewController(nibName: "RateViewController", bundle: nil)
        menuVC.rateUrl = restaurant!.menu_url!
        menuVC.restaurant = restaurant
        menuVC.navigationTitle = "re_menu_nav_bar"
        
        self.navigationController?.pushViewController(menuVC, animated: false)
        
    }
    func pressedButton3(tableCourseHeader: ViewForDetailHeader, button3Pressed button2: AnyObject) {
        
        let packageVC = UIStoryboard(name:"Main", bundle: nil).instantiateViewControllerWithIdentifier("OffersViewController") as! OffersViewController
        packageVC.packageUrl = restaurant!.package_url
        packageVC.titleOfferts = "re_suggestion_nav_bar"
        packageVC.offertsArray = restaurant?.packagesList
        packageVC.restaurant = restaurant
        self.navigationController?.pushViewController(packageVC, animated: false)
        
    }
    
    //MARK: Overrided methods
    
    override func showPreviousController() {
        
        if restaurantsCount > 1 {
            self.navigationController?.popViewControllerAnimated(false)
            
        }else {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
}
