//
//  CourseDetailViewController.swift
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

class CourseDetailViewController: BaseViewController , CourseHeaderDelegate, UITableViewDelegate, UITableViewDataSource{

    let categories = ViewForDetailHeader.loadViewFromNib()
    var course : Course!
    var arrayOfImages = [String]()
    var courseCount = 1
    
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureNavBar()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("crs_the_course_detail_nav_bar")
        
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
        self.setupHeaderView()
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.headerView.backgroundColor = Global.viewsBackgroundColor
        self.view.backgroundColor = Global.viewsBackgroundColor
        self.tableView.estimatedRowHeight = 80;
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
            lCell.imagesArray = self.course.images
            
            return lCell
        }
        
        let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
        cell2.nameLabel.text = course.name
        cell2.detailLabel.text = "\(course.holes) \(LocalisationDocument.sharedInstance.getStringWhinName("holes")) - " +
            "\(course.par) pare - \(course.length) \(course.length_unit)"
        cell2.descriptionLabel.text = course.descr
        cell2.newNewsImageView.hidden = true
        
        return cell2
        
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
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let setViewController = mainStoryboard.instantiateViewControllerWithIdentifier("SwipePageCourseController") as! SwipePageCourseController
        setViewController.courseImage = arrayOfImages
        self.navigationController?.pushViewController(setViewController, animated: false)
        
    }
    func pressedButton2(tableCourseHeader: ViewForDetailHeader, button2Pressed button2: AnyObject) {
        
        let mainStoryboard : UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let setViewController = mainStoryboard.instantiateViewControllerWithIdentifier("FacilitesCollectionViewController") as! FacilitesCollectionViewController
        setViewController.facilites = course.facilities
        self.navigationController?.pushViewController(setViewController, animated: false)
    }
    func pressedButton3(tableCourseHeader: ViewForDetailHeader, button3Pressed button2: AnyObject) {
        
        let vc = RateViewController(nibName: "RateViewController", bundle: nil)
        vc.rateUrl = course.rate_url
        vc.course = course
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    //MARK: Private methods
    func setupHeaderView() {
        categories.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, headerView.frame.size.height)
        headerView.addSubview(categories)
        
        categories.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("crs_the_course_btn"), forState: .Normal)
        categories.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("crs_facilities_btn"), forState: .Normal)
        categories.button3.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("crs_rates_btn"), forState: .Normal)
        
        categories.setButtonEnabled(categories.button1, enabled: arrayOfImages.count > 0 ? true : false)
        categories.setButtonEnabled(categories.button2, enabled: true)
        categories.setButtonEnabled(categories.button3, enabled: course.rate_count.intValue > 0 ? true : false)
        categories.delegate = self
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSwipeCourseController" {
            let destinationController = segue.destinationViewController as! SwipePageCourseController
            destinationController.courseImage = arrayOfImages
        }

    }
    
    //MARK: Overrided methods
    
    override func showPreviousController() {
        
        if courseCount > 1 {
            self.navigationController?.popViewControllerAnimated(false)
            
        }else {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }

}
