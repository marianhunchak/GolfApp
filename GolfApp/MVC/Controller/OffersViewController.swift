//
//  OffersViewController.swift
//  GolfApp
//
//  Created by Admin on 18.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import MagicalRecord

private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailDescriptionCellNibName = "DetailInfoCell"

class OffersViewController: UIViewController , OffersHeaderDelegate,UITableViewDelegate, UITableViewDataSource  {
    
    let viewForHead = ViewForOffersHeader.loadViewFromNib()
    var seleted = false
    var shareItem = -1
    var offertsArray : [Package]!
    var packageUrl: String?
    var titleOfferts = "re_suggestion_nav_bar"
    var hotel : Hotel!
    var pros : Pros!
    var prosShop : ProsShop!
    var restaurant : Restaurant?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var offersTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName(titleOfferts)

        self.configureNavBar()
        setupHeaderView()
        
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        offersTableView.backgroundColor = Global.viewsBackgroundColor
        
        self.offersTableView.estimatedRowHeight = 80;
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        self.offersTableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
        switch titleOfferts {
            
        case "re_suggestion_nav_bar":
            NetworkManager.sharedInstance.getSuggestions(urlToPackage: packageUrl ?? "") { (array) in
                self.offertsArray = array!
                self.offersTableView.reloadData()
                self.restaurant?.packagesList = array
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            }
        case "ps_special_offer_nav_bar":
            NetworkManager.sharedInstance.getPackages(urlToPackage: packageUrl ?? "") { (array) in
                self.offertsArray = array!
                self.offersTableView.reloadData()
                self.prosShop.packagesList = array
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            }
        case "pro_rate_offer_nav_bar":
            NetworkManager.sharedInstance.getPackages(urlToPackage: packageUrl ?? "") { (array) in
                self.offertsArray = array!
                self.offersTableView.reloadData()
                self.pros.packagesList = array!
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            }
            
        case "htl_package_list_nav_bar":
            NetworkManager.sharedInstance.getPackages(urlToPackage: packageUrl ?? "") { (array) in
                self.offertsArray = array!
                self.offersTableView.reloadData()
                self.hotel.packagesList = array!
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
            }
            
        default:
            break
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false;
    }
    
    //MARK: UITableViewDelegate
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    
        
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

        return offertsArray == nil ? 0 : offertsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell

        let lPackage = offertsArray[indexPath.row]
        cell.nameLabel.text = lPackage.name
        cell.detailLabel.text = lPackage.subtitle
        cell.descriptionLabel.text = lPackage.descr
        if shareItem == indexPath.row {
            cell.setCellSelected()
        }
        
        return cell
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {

        return UITableViewAutomaticDimension
    }

    //MARK: Private methods
    
    func setupHeaderView() {
        viewForHead.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width , backgroundView.frame.size.height)
        backgroundView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_share_btn"), forState: .Normal)
        viewForHead.delegate = self
       
    }
    
    func pressedButton1(tableProHeader: ViewForOffersHeader, button1Pressed button1: AnyObject) {
        
        let lPackege = offertsArray[shareItem]
        let textToShare = lPackege.name + "\n" + lPackege.subtitle + "\n" + lPackege.descr
        let urlToShare = "http://golfapp.ch"
        
        if let myWebsite = NSURL(string: urlToShare) {
            let activityVC = UIActivityViewController(activityItems: [myWebsite, textToShare], applicationActivities: [])
            self.navigationController!.presentViewController(activityVC, animated: true, completion: nil)
        }
    }

}
