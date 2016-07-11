//
//  NewsDetailController.swift
//  GolfApp
//
//  Created by Admin on 10.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

private let cellImagereuseIdentifier = "detailImageTableCell"
private let NewsTableCellIndetifire = "NewsDetailCell"

class NewsDetailController: BaseViewController , OffersHeaderDelegate {
    
    var news : New!
    var newsCount = 1
    let viewForHead = ViewForOffersHeader.loadViewFromNib()
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
    
    @IBOutlet weak var headerView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configureNavBar()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("nws_detail_nav_bar")
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.headerView.backgroundColor = Global.viewsBackgroundColor
        
        let nib = UINib.init(nibName: "DetailmageTableCell", bundle: nil)
        self.tableView.registerNib(nib, forCellReuseIdentifier: cellImagereuseIdentifier)
        
        let nibFood = UINib.init(nibName: NewsTableCellIndetifire, bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: NewsTableCellIndetifire)
        self.tableView.estimatedRowHeight = 1000
        
        self.setupHeaderView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        checkInternet()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
        cell.imagesArray = news.images!
        return cell
    }
    
    
    //MARK: Private methods
    func setupHeaderView() {
        
        viewForHead.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, headerView.frame.size.height)
        headerView.addSubview(viewForHead)
        viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
        
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
    
    //MARK: Overrided methods
    
    override func showPreviousController() {
        
        if newsCount > 1 {
            self.navigationController?.popViewControllerAnimated(false)
            
        }else {
            self.navigationController?.popToRootViewControllerAnimated(false)
        }
    }
    
    // MARK: Private methods
    
    func checkInternet(){
        if appDelegate.reachability?.isReachable() == true {
            NetworkManager.sharedInstance.getAdvertisemet { (aAdvertisemet) in
                self.advertisemet = aAdvertisemet
                self.checkDate()
                
            }
        } else {
            
            if let lAdvertisemnt = Advertisemet.MR_findFirst() {
                self.advertisemet = lAdvertisemnt as? Advertisemet
                self.checkDate()
            }
        }
    }
    
    func showPopUpView() {
        
        let popUpView = PopUpView.loadViewFromNib()
        
        popUpView.frame = CGRectMake(0, 0,
                                     (UIApplication.sharedApplication().keyWindow?.frame.size.width)!,
                                     (UIApplication.sharedApplication().keyWindow?.frame.size.height)!)
        
        let lImage  = Image(name: (advertisemet?.name)!, url: (advertisemet?.image)!)
        
        popUpView.websiteUrl = advertisemet?.url
        popUpView.poupImage = lImage
        
        self.navigationController?.view.addSubview(popUpView)
        self.navigationController?.view.bringSubviewToFront(popUpView)
        
    }
    
    func saveExitDate(notification : NSNotification) {
        let calendar = NSCalendar.currentCalendar()
        let dateComponent = NSDateComponents()
        dateComponent.second = 10
        let todaysDate : NSDate = NSDate()
        let dateformater : NSDateFormatter = NSDateFormatter()
        dateformater.dateFormat = "MM-dd-yyyy HH:mm:ss"
        
        let date = calendar.dateByAddingComponents(dateComponent, toDate: todaysDate, options: NSCalendarOptions.init(rawValue: 0))
        let dateInFormat = dateformater.stringFromDate(date!)
        
        defaults.setObject(dateInFormat, forKey: "lastLoadDate")
        defaults.synchronize()
        
    }
    
    func checkDate() {
        
        if let lastLoaded = defaults.objectForKey("lastLoadDate") as? String {
            
            let todaysDate : NSDate = NSDate()
            let dateFormater = NSDateFormatter()
            dateFormater.dateFormat = "MM-dd-yyyy HH:mm:ss"
            let lastLoadedDate = dateFormater.dateFromString(lastLoaded)
            
            let showPopUp = lastLoadedDate?.compare(todaysDate)
            
            if showPopUp == .OrderedAscending {
                
                print("Time to show Pop Up View!")
                showPopUpView()
                
            } else {
                print("This is not time to show Pop Up View!")
            }
            
        }
    }

}
