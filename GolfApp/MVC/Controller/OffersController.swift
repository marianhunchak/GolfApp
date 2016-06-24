//
//  OffersController.swift
//  GolfApp
//
//  Created by Admin on 10.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import MagicalRecord

private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailDescriptionCellNibName = "DetailInfoCell"

class OffersController: BaseViewController , OffersHeaderDelegate,UITableViewDelegate, UITableViewDataSource{
    
    let viewForHead = ViewForOffersHeader.loadViewFromNib()
    var seleted = false
    var shareItem = -1
    var offertsArray : [Package]?
    var packageUrl: String?
    var titleOfferts = "re_suggestion_nav_bar"
    var hotel : Hotel!
    var pros : Pros!
    var prosShop : ProsShop!
    var restaurant : Restaurant?
   // var loadFromPreviosController = true
    
    @IBOutlet weak var backgroundView: UIView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName(titleOfferts)
        
        self.configureNavBar()
        setupHeaderView()
        
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        self.tableView.estimatedRowHeight = 80;
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        if shareItem != -1 {
            tableView.delegate?.tableView!(tableView, didDeselectRowAtIndexPath: NSIndexPath(forRow: shareItem, inSection: 0))
        }
        
        viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
        shareItem = indexPath.row
        
        let selectedCell = tableView.cellForRowAtIndexPath(indexPath) as! DetailInfoCell
        selectedCell.setCellSelected()
    }
    
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
        if let deselectedCell = tableView.cellForRowAtIndexPath(indexPath) as? DetailInfoCell {
            deselectedCell.backgroundCourseFooter.backgroundColor = Global.descrTextBoxColor
            deselectedCell.nameLabel.textColor = Global.navigationBarColor
            deselectedCell.backgroundCourseFooter.layer.borderWidth = 0.0
        }
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return offertsArray == nil ? 0 : offertsArray!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
        
        let lPackage = offertsArray![indexPath.row]
        cell.nameLabel.text = lPackage.name
        cell.detailLabel.text = lPackage.subtitle
        cell.descriptionLabel.text = lPackage.descr
        cell.tag = indexPath.row
        cell.tableView = tableView
        if shareItem == indexPath.row {
            cell.setCellSelected()
        }
        
        if titleOfferts == "re_suggestion_nav_bar" {
            let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND post_id = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "restaurant", lPackage.id])
            
            if  Notification.MR_findFirstWithPredicate(lPredicate) as? Notification != nil {
                cell.displayNewNewsImage = true
            }

        } else if titleOfferts == "ps_special_offer_nav_bar" {
            let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND post_id = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "proshop", lPackage.id])
            
            if  Notification.MR_findFirstWithPredicate(lPredicate) as? Notification != nil {
                cell.displayNewNewsImage = true
            }
        } else if titleOfferts == "pro_rate_offer_nav_bar" {
            let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND post_id = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "pros", lPackage.id])
            
            if  Notification.MR_findFirstWithPredicate(lPredicate) as? Notification != nil {
                cell.displayNewNewsImage = true
            }
        }else if titleOfferts == "htl_package_list_nav_bar" {
           
            let lPredicate = NSPredicate(format: "language_id = %@ AND post_type = %@ AND post_id = %@", argumentArray: [NSNumber(integer: Int(Global.languageID)!), "hotel", lPackage.id])
            
            if  Notification.MR_findFirstWithPredicate(lPredicate) as? Notification != nil {
                cell.displayNewNewsImage = true
            }
            
        }

        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        
        return UITableViewAutomaticDimension
    }
    
    //MARK: Private methods
    
    func setupHeaderView() {
        
        viewForHead.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, backgroundView.frame.size.height)
        backgroundView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_share_btn"), forState: .Normal)
        viewForHead.delegate = self
        
    }
    
    func pressedButton1(tableProHeader: ViewForOffersHeader, button1Pressed button1: AnyObject) {
        
        let lPackege = offertsArray![shareItem]
        let textToShare = lPackege.name + "\n" + lPackege.subtitle + "\n" + lPackege.descr
        let urlToShare = "http://golfapp.ch"
        
        if let myWebsite = NSURL(string: urlToShare) {
            let activityVC = UIActivityViewController(activityItems: [myWebsite, textToShare], applicationActivities: [])
            self.navigationController!.presentViewController(activityVC, animated: true, completion: nil)
        }
    }
    

    override func refresh(sender: AnyObject) {
        if offertsArray!.isEmpty {
            print(offertsArray!.count)
            refreshControl?.beginRefreshing()
        
        }
        
        loadDataFromServer()
    }
    
    func loadDataFromServer() {
        
        switch titleOfferts {
            
        case "re_suggestion_nav_bar":
            NetworkManager.sharedInstance.getSuggestions(urlToPackage: packageUrl ?? "") { (array) in
                
                if let lArray = array {
                    self.offertsArray = lArray
                    self.tableView.reloadData()
                    self.restaurant?.packagesList = array
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                     self.removeNotificationsWithsID(self.restaurant!.id!, andPostType: "restaurant")
                    print("<<<<<<<<<<<<\(self.packageUrl)>>>>>>>>>")
                }
                self.refreshControl?.endRefreshing()
            }
        case "ps_special_offer_nav_bar":
            NetworkManager.sharedInstance.getPackages(urlToPackage: packageUrl ?? "") { (array) in
   
                if let lArray = array {
                    self.offertsArray = lArray
                    self.tableView.reloadData()
                    self.prosShop.packagesList = array
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    self.removeNotificationsWithsID(self.prosShop.id!, andPostType: "proshop")
                    print("<<<<<<<<<<<<\(self.packageUrl)>>>>>>>>>")
                }
                self.refreshControl?.endRefreshing()
            }
        case "pro_rate_offer_nav_bar":
            NetworkManager.sharedInstance.getPackages(urlToPackage: packageUrl ?? "") { (array) in
                
                if let lArray = array {
                    self.offertsArray = lArray
                    self.tableView.reloadData()
                    self.pros.packagesList = array!
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    self.removeNotificationsWithsID(self.pros.id!, andPostType: "pros")
                    print("<<<<<<<<<<<<\(self.packageUrl)>>>>>>>>>")
                    
                }
                
                self.refreshControl?.endRefreshing()
                
            }
            
        case "htl_package_list_nav_bar":
            NetworkManager.sharedInstance.getPackages(urlToPackage: packageUrl ?? "") { (array) in
                
                if let lArray = array {
                    
                    self.offertsArray = lArray
                    self.tableView.reloadData()
                    
                    print("<<<<<<<<<<<<\(self.packageUrl)>>>>>>>>>")
//                    self.hotel.packagesList = array!
//                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
//                    self.removeNotificationsWithsID(self.hotel.id!, andPostType: "hotel")
                }
                self.refreshControl?.endRefreshing()

            }
            
        default:
            break
        }
        
    }

    
}
