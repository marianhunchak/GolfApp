//
//  ParcoursTableController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "parcoursCell"
private let parcouseTableCellNibname = "CoursTableCell"
private let indifireOfDetailTableController = "DetailViewController"

private let course_1_Images = ["course_1_hole_1.jpg",  "course_1_hole_2.jpg",  "course_1_hole_3.jpg",
                               "course_1_hole_4",      "course_1_hole_5.jpg",  "course_1_hole_6.jpg",
                               "course_1_hole_7.jpg",  "course_1_hole_8.jpg",  "course_1_hole_9.jpg",
                               "course_1_hole_10.jpg", "course_1_hole_11.jpg", "course_1_hole_12.jpg",
                               "course_1_hole_13.jpg", "course_1_hole_14.jpg", "course_1_hole_15.jpg",
                               "course_1_hole_16.jpg", "course_1_hole_17.jpg", "course_1_hole_18.jpg"]

private let course_2_Images = ["course_2_hole_1.jpg", "course_2_hole_2.jpg", "course_2_hole_3.jpg",
                               "course_2_hole_4",     "course_2_hole_5.jpg", "course_2_hole_6.jpg",
                               "course_2_hole_7.jpg", "course_2_hole_8.jpg", "course_2_hole_9.jpg"]

private let coursesImages = [course_1_Images, course_2_Images]


class ListTableController: BaseTableViewController {

    var coursesArray = [Course]()
    
    //MARK: Lifecycle
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false;
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("crs_the_course_list_nav_bar")

        let nib = UINib(nibName: parcouseTableCellNibname, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        NetworkManager.sharedInstance.getCours { array in
            self.coursesArray = array!
            self.tableView.reloadData()
        }
        self.refreshControl?.addTarget(self, action:#selector(ListTableController.reloadAllData(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.coursesArray.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CoursTableCell
        cell.course = coursesArray[indexPath.row] 
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(indifireOfDetailTableController) as! DetailViewController
        
        vc.course = coursesArray[indexPath.row]
        vc.arrayOfImages = coursesImages[indexPath.row]
        vc.facilitiesArray = coursesArray[indexPath.row].facilities as! [String]
        vc.urlToRate = coursesArray[indexPath.row].rate_url as String


        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - Private methods
    
    func reloadAllData(sender:AnyObject) {
        
        NetworkManager.sharedInstance.getCours { array in
            self.coursesArray = array!
            dispatch_async(dispatch_get_main_queue(), { 
                self.tableView.reloadData()
                self.refreshControl?.endRefreshing()
            })
        
        }
    }
}
