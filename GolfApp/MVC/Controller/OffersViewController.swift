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

class OffersViewController: BaseViewController , UITableViewDelegate, UITableViewDataSource  {
    
    let viewForHead = ViewForOffersHeader.loadViewFromNib()
    
    var offertsArray = [Pro]()
    
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
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.offertsArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
        
       // let lOfferts = offertsArray[indexPath.row].pack
        print(offertsArray[indexPath.row].pack.count)

        cell.nameLabel.text = "11111"
         cell.detailLabel.text = "22222"
        cell.descriptionLabel.text = "Sensors help people make better decisions. Airline pilots can quickly read the real-time status of engines and control gear. Surgeons can access areas of the body once thought impossible to reach. Robots can collaborate with people to perform difficult – and often dangerous – factory tasks with unprecedented precision."
        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }


    //MARK: Private methods
    func setupHeaderView() {
        viewForHead.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width , backgroundView.frame.size.height)
        backgroundView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("ps_share_btn"), forState: .Normal)

        
      //  viewForHead.delegate = self
    }
    
    func pressedButton1(tableProHeader: ViewForProHeader, button1Pressed button1: AnyObject) {
        print("Some Action")
    }

}
