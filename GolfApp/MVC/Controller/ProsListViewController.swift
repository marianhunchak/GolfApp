//
//  ProsListViewController.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private var reuseIdentifier = "ProsTableCell"
private let parcouseTableCellNibname = "ProsTableCell"
private let detailProsControllerIdentfier = "detailProsControllerIdentfier"

class ProsListViewController: BaseViewController ,UITableViewDelegate ,UITableViewDataSource{

    var prosArray = [Pros]()
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var prosTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("pro_list_nav_bar")
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: parcouseTableCellNibname, bundle: nil)
        self.prosTableView.registerNib(nib, forCellReuseIdentifier: reuseIdentifier)

        NetworkManager.sharedInstance.getPros { array in
            self.prosArray = array!
//            print("<<<<\(self.prosArray)>>>>")
            self.prosTableView.reloadData()
        }
//         refreshControl?.addTarget(self, action:#selector(ProsListViewController.reloadAllData(_:)), forControlEvents: UIControlEvents.ValueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.hidden = false;
    }
    
    // MARK: - Table view data source
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.prosArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(reuseIdentifier, forIndexPath: indexPath) as! ProsTableCell

        cell.prosLabel.text = prosArray[indexPath.row].name
        
        cell.imageForCell = prosArray[indexPath.row].images.first

        
        return cell
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return self.view.frame.height / 3.0
    }
    // MARK: - UITableViewDelegate
     func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier(detailProsControllerIdentfier) as! ProsViewController
//
//        if indexPath.row < coursesImages.count {
//            vc.arrayOfImages =  coursesImages[indexPath.row]
//        }
//        vc.course = coursesArray[indexPath.row]
//        vc.facilitiesArray = coursesArray[indexPath.row].facilities
//        vc.urlToRate = coursesArray[indexPath.row].rate_url as String
        vc.package_url = prosArray[indexPath.row].package_url!
        //vc.prosArray = prosArray
        vc.pros = prosArray[indexPath.row]
        
        self.navigationController?.pushViewController(vc, animated: true)

    }
    
    // MARK: - Private methods
    
    func reloadAllData(sender:AnyObject) {
        
        NetworkManager.sharedInstance.getPros { array in
            self.prosArray = array!
            dispatch_async(dispatch_get_main_queue(), {
                self.prosTableView.reloadData()
                //self.refreshControl?.endRefreshing()
            })
            
        }
    }


}
