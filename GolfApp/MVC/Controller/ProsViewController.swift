//
//  ProsViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/16/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let reuseIdentifier = "detailImageTableCell"
private let courseFooterIndetifire = "courseFooterIndetifire"
private let detailImageTableCellNibName = "DetailmageTableCell"
private let detailDescriptionCellNibName = "DetailInfoCell"
private let segueIdetifireToSwipeCourseController = "showSwipeCourseController"

class ProsViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    var proArray = [Pro]()
    //var prosArray = [Pros]()
    var pros = Pros()
    var package_url = String()
    let viewForHead = ViewForProHeader.loadViewFromNib()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var prosTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupHeaderView()
        
        NetworkManager.sharedInstance.getPackages(urlToPackage: package_url) { array in
            self.proArray = array!

        }
        
        let nib = UINib.init(nibName: detailImageTableCellNibName, bundle: nil)
        prosTableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)
        
        let nibFood = UINib.init(nibName: detailDescriptionCellNibName, bundle: nil)
        prosTableView.registerNib(nibFood, forCellReuseIdentifier: courseFooterIndetifire)
        
        self.prosTableView.estimatedRowHeight = 80;
        prosTableView.backgroundColor = Global.viewsBackgroundColor
    }

    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let lCell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
            lCell.imagesArray = pros.images
            
            
            
            return lCell
        }
            
        else if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCellWithIdentifier(courseFooterIndetifire, forIndexPath: indexPath) as! DetailInfoCell
           cell2.nameLabel.text = pros.name
            cell2.detailLabel.hidden = true
            cell2.descriptionLabel.text = pros.descr
         

            return cell2
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
        cell.imagesArray = pros.images
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK: Private methods
    func setupHeaderView() {
        viewForHead.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width , headerView.frame.size.height)
        headerView.addSubview(viewForHead)
    }

}
