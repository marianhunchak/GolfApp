//
//  NewsTableViewController.swift
//  GolfApp
//
//  Created by Admin on 20.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private var newsTableCellIdentifier = "NewsTableCell"

class NewsTableViewController: BaseTableViewController {

    var newsArray = [News]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("nws_nav_bar")
        tableView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib(nibName: newsTableCellIdentifier, bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: newsTableCellIdentifier)
        
        self.tableView.estimatedRowHeight = 1000

        NetworkManager.sharedInstance.getNews { (nNews) in
            self.newsArray = nNews!
            self.showRestaurantDetailView()
        }
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


    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return newsArray.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NewsTableCell", forIndexPath: indexPath) as! NewsTableCell
        
        cell.nameLabel.text = newsArray[indexPath.row].title
        cell.subtitleLabel.text = newsArray[indexPath.row].subtitle
        cell.dateLabel.text = newsArray[indexPath.row].pubdate
        cell.descriptionLabel.text = newsArray[indexPath.row].descr
        cell.descriptionLabel.numberOfLines = 1
        
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
     
            return UITableViewAutomaticDimension
        
    }
    // MARK: - UITableViewDelegate
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let vc = self.storyboard?.instantiateViewControllerWithIdentifier("NewsDetailViewController") as! NewsDetailViewController
        vc.news = newsArray[indexPath.row]
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    // MARK: - Private methods
    
    func reloadAllData(sender:AnyObject) {
        
        NetworkManager.sharedInstance.getNews { array in
            self.newsArray = array!
            dispatch_async(dispatch_get_main_queue(), {
                self.tableView.reloadData()
            })
        }
    }
    
    func showRestaurantDetailView() {
        
        if self.newsArray.count == 1 {
            let newsVC = self.storyboard?.instantiateViewControllerWithIdentifier("NewsDetailViewController") as! NewsDetailViewController
            newsVC.news = newsArray[0]
            self.navigationController?.pushViewController(newsVC, animated: true)
        } else {
            
            tableView.reloadData()
            
        }
        
    }
}
