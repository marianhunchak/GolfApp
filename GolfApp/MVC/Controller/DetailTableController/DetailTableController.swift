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


class DetailTableController: UITableViewController , CourseHeaderDelegate {
  
    var course = Course()
    var arrayOfImages = [String]()
    var facilitiesArray = [String]()
    var urlToRate = String()
    var rateArray = [Rate]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(urlToRate)

        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("crs_the_course_detail_nav_bar")
        
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)

        
        NetworkManager.sharedInstance.getRate(urlToRate: urlToRate) { array in
            self.rateArray = array!

            if self.rateArray.count > 0 {
            
                print(self.rateArray.count)
                print(self.rateArray[0].section)
                print(self.rateArray[0].position)
                print(self.rateArray[0].items)
                
                print(self.rateArray[1].section)
                print(self.rateArray[1].position)
                print(self.rateArray[1].items)
            
                print(self.rateArray[2].section)
                print(self.rateArray[2].position)
                print(self.rateArray[2].items)
            } else {
            
                print("No Rates")
            
            }
            
        }
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
            let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
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
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    override func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }

    
    override func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {

        let categories : ViewForDetailHeader = ViewForDetailHeader.loadViewFromNib()
        categories.center = self.view.center
        categories.frame = CGRectMake(0.0, 0.0, tableView.frame.width , tableView.frame.height )
        categories.delegate = self
        
        return categories
    }
    
    func tableCourseHeader(tableCourseHeader: ViewForDetailHeader, button1Pressed button1: AnyObject) {
         self.performSegueWithIdentifier(segueIdetifireToSwipeCourseController, sender: self)
    }
    
    func pressedButton2(tableCourseHeader: ViewForDetailHeader, button2Pressed button2: AnyObject) {
        self.performSegueWithIdentifier("showFacilites", sender: self)
    }
    func pressedButton3(tableCourseHeader: ViewForDetailHeader, button3Pressed button2: AnyObject) {
        self.performSegueWithIdentifier("showRates", sender: self)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showSwipeCourseController" {
            let destinationController = segue.destinationViewController as! SwipePageCourseController
            destinationController.courseImage = arrayOfImages
        }
        if segue.identifier == "showFacilites" {
            let destinationController = segue.destinationViewController as! FacilitesCollectionViewController
            destinationController.facilitesOnItemsImgArray = facilitiesArray
        }
        if segue.identifier == "showRates" {
            let destinationController = segue.destinationViewController as! RateViewController
            destinationController.rateArray = rateArray
        }
    }

}
