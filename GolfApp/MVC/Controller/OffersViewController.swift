//
//  OffersViewController.swift
//  GolfApp
//
//  Created by Admin on 18.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailDescriptionCellNibName = "DetailInfoCell"

class OffersViewController: BaseViewController , OffersHeaderDelegate,UITableViewDelegate, UITableViewDataSource  {
    
    let viewForHead = ViewForOffersHeader.loadViewFromNib()
    var seleted = false
    var shareItem : Int!
    var offertsArray = [Package]()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var offersTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderView()
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        offersTableView.backgroundColor = Global.viewsBackgroundColor
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("ps_special_offer_nav_bar")
        
        self.offersTableView.estimatedRowHeight = 80;
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        self.offersTableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
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
    
        if seleted == false {
            viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
            seleted = true
            shareItem = indexPath.row
            print(shareItem)
        } else {
        
            viewForHead.setButtonEnabled(viewForHead.button1, enabled: false)
            seleted = false
            
        }
    
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        
        return offertsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell

            cell.nameLabel.text = offertsArray[indexPath.row].name
            cell.detailLabel.text = offertsArray[indexPath.row].subtitle
            cell.descriptionLabel.text = offertsArray[indexPath.row].descr

        
        return cell
    }
    
    //MARK: Size
    
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
        print("Some action")
    }

}
