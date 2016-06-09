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
private let detailConreoolerIdentfier = "DetailViewController"

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
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataSource.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! CoursTableCell
        
        let lCourse = dataSource[indexPath.row] as! Course
        cell.imageForCell = lCourse.images.first
        cell.cellItemLabel.text = lCourse.name
        cell.cellInfoLabel.text = lCourse.holes + " \(LocalisationDocument.sharedInstance.getStringWhinName("holes")) - Par " +
                                  lCourse.par + " - " + lCourse.length + " " + lCourse.length_unit
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {

        
        let vc = CourseDetailViewController(nibName: "CourseDetailViewController", bundle: nil)
        
        vc.course = dataSource[indexPath.row] as! Course
        if indexPath.row < coursesImages.count {
        vc.arrayOfImages =  coursesImages[indexPath.row]
        }
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    // MARK: Overrided methods
    
    override func loadDataFromDB() {
        
        loadedFromDB = true
        dataSource = Course.MR_findAllSortedBy("createdDate", ascending: true)
        print("DataSource count = \(dataSource.count)")
        tableView.reloadData()
    }
    
    override func loadDataWithPage(pPage: Int, completion: (Void) -> Void) {
        
        NetworkManager.sharedInstance.getCourseseWithPage(pPage, completion: {
            (array, error) in
            
            if self.loadedFromDB {
                self.dataSource = []
                self.loadedFromDB = false
            }
            
            if let lArray = array {
                
                self.dataSource += lArray
                if lArray.count >= 10 {
                    self.allowLoadMore = true
                    self.allowIncrementPage = true
                    self.addInfiniteScroll()
                } else {
                    self.allowLoadMore = false
                    self.tableView.removeInfiniteScroll()
                }
                
                NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                
            } else if error != nil {
                self.allowIncrementPage = false
                self.handleError(error!)
            }
            
            completion()
        })
    }
}
