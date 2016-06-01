//
//  NewsDetailViewController.swift
//  GolfApp
//
//  Created by Admin on 20.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellImagereuseIdentifier = "detailImageTableCell"
private let NewsTableCellIndetifire = "NewsDetailCell"

class NewsDetailViewController: UIViewController, OffersHeaderDelegate {
    
    var news = News()
    var newsCount = 1
    let viewForHead = ViewForOffersHeader.loadViewFromNib()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("nws_detail_nav_bar")
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.headerView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib.init(nibName: "DetailmageTableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellImagereuseIdentifier)
        
        let nibFood = UINib.init(nibName: NewsTableCellIndetifire, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: NewsTableCellIndetifire)
        self.tableView.estimatedRowHeight = 1000
        
        self.setupHeaderView()
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return 2
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if indexPath.row == 1{
            let cell2 = tableView.dequeueReusableCellWithIdentifier("NewsDetailCell", forIndexPath: indexPath) as! NewsDetailCell
            cell2.nameLabel.text = news.title
            cell2.subtitleLabel.text = news.subtitle
            cell2.dateLabel.text = news.pubdate
            cell2.descriptionNews.text = news.descr
            
            
            return cell2
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(cellImagereuseIdentifier, forIndexPath: indexPath) as! DetailmageTableCell
        cell.imagesArray = news.images
        return cell
    }
    
    
    //MARK: Private methods
    func setupHeaderView() {
        
        viewForHead.frame = CGRectMake(0.0, 0.0, self.view.frame.size.width , headerView.frame.size.height)
        viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
        headerView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("nws_share_btn"), forState: .Normal)
        viewForHead.delegate = self
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if indexPath.row == 0 {
            return self.view.frame.height / 3.0
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    //MARK: CourseHeaderDelegate
    
    func pressedButton1(tableProHeader: ViewForOffersHeader, button1Pressed button1: AnyObject) {

        let textToShare = news.title + "\n" + news.subtitle + "\n" + news.pubdate + "\n" + news.descr
        let urlToShare = "http://golfapp.ch"
        
        if let myWebsite = NSURL(string: urlToShare) {
            let activityVC = UIActivityViewController(activityItems: [myWebsite, textToShare], applicationActivities: [])
            self.navigationController!.presentViewController(activityVC, animated: true, completion: nil)
        }
        

    }
    


}