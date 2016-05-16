//
//  DetailTableController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/9/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "detailImageTableCell"
private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailImageTableCellNibName = "DetailmageTableCell"
private let detailDescriptionCellNibName = "DetailInfoCell"
private let segueIdetifireToSwipeCourseController = "showSwipeCourseController"


class DetailViewController: BaseViewController , CourseHeaderDelegate, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!
    var course = Course()
    var arrayOfImages = [String]()
    let categories = ViewForDetailHeader.loadViewFromNib()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("crs_the_course_detail_nav_bar")
        
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
        self.setupHeaderView()
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.view.backgroundColor = Global.viewsBackgroundColor
        self.tableView.estimatedRowHeight = 80;
//        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let lCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
            if let lArray = self.course.images {
                lCell.imagesArray = lArray as! [NSDictionary]
                return lCell
            }
        }
        
        else if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
            cell2.nameLabel.text = course.name
            cell2.detailLabel.text = "\(course.holes) \(LocalisationDocument.sharedInstance.getStringWhinName("holes")) - " +
                                     "\(course.par) pare - \(course.length) \(course.length_unit)"
            cell2.descriptionLabel.text = course.description_
            
            return cell2
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
        if let lArray = self.course.images {
            cell.imagesArray = lArray as! [NSDictionary]
            return cell
        }
        return cell
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
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("SwipePageCourseController") as! SwipePageCourseController
        vc.courseImage = arrayOfImages
        self.navigationController?.pushViewController(vc, animated: true)
    }

    //MARK: Private methods
    
    func setupHeaderView() {
        categories.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width , headerView.frame.size.height)
        headerView.addSubview(categories)
        if arrayOfImages.count > 0 {
            categories.button1Available = true
        }
        categories.delegate = self
    }
}
