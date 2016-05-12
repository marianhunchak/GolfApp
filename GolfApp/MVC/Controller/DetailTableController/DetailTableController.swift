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
private let detailDescriptionCellNibName = "DetailCouseFooter"
private let segueIdetifireToSwipeCourseController = "showSwipeCourseController"


class DetailTableController: UITableViewController , CourseHeaderDelegate {
  
    var course = Course()
    var arrayOfImages = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
    }
    
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 0 {
             let lCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
            if let lArray = self.course.images {
                lCell.imagesArray = lArray as! [NSDictionary]
                return lCell
            }
        }
        
        else if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailCouseFooter
            cell2.nameLabel.text = course.name
            cell2.detailLabel.text = "\(course.holes) hole -\(course.par) pare -\(course.length) metres"
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
    
    //Mark: - Size
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let categories : DetailCourseHeader = DetailCourseHeader.loadViewFromNib()
        categories.center = self.view.center
        categories.frame = CGRectMake(0.0, 0.0, tableView.frame.width , tableView.frame.height )
        categories.alpha = 1
        categories.delegate = self
        return categories
    }
    
    func tableCourseHeader(tableCourseHeader: DetailCourseHeader, button1Pressed button1: AnyObject) {
         self.performSegueWithIdentifier(segueIdetifireToSwipeCourseController, sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSwipeCourseController" {
            let destinationController = segue.destinationViewController as! SwipePageCourseController
            destinationController.courseImage = arrayOfImages
        }
    }

}
