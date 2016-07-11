//
//  EventDetailController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/24/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import PKHUD

private let eventDetailCellIdentifier = "eventDetailCell"
private let cellImagereuseIdentifier = "detailImageTableCell"
private let newsCellIndetifire = "NewsDetailCell"
private let detailCellHeight: CGFloat = 465

class EventDetailController: BaseTableViewController, EventDetailCellDelegate, UIDocumentInteractionControllerDelegate {
    
    var event : Event!
    var documentInteractionController : UIDocumentInteractionController?
    var advertisemet: Advertisemet?
    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshControl?.endRefreshing()
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("evt_detail_page_nav_bar")
        
        let nib = UINib(nibName: "EventDetailCell", bundle: nil)
        tableView.registerNib(nib, forCellReuseIdentifier: eventDetailCellIdentifier)
        
        let nibFood = UINib.init(nibName: "NewsDetailCell", bundle: nil)
        self.tableView.registerNib(nibFood, forCellReuseIdentifier: newsCellIndetifire)
        self.tableView.estimatedRowHeight = 1000
        self.refreshControl?.removeFromSuperview()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(saveExitDate(_:)), name: UIApplicationWillResignActiveNotification, object: nil)
        checkInternet()
    }

    // MARK: - UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if indexPath.row == 0 {
            let cell = tableView.dequeueReusableCellWithIdentifier(newsCellIndetifire, forIndexPath: indexPath) as! NewsDetailCell
            
            let dateString:String = event.event_date
            let dateFormat = NSDateFormatter.init()
            dateFormat.dateStyle = .FullStyle
            dateFormat.dateFormat = "yyyy-MM-dd"
            
            let dateFormat2 = NSDateFormatter.init()
            dateFormat2.dateStyle = .FullStyle
            dateFormat2.dateFormat = "dd-MM-yyyy"
            
            let date:NSDate? = dateFormat.dateFromString(dateString)
            let stringOfDateInNewFornat = dateFormat2.stringFromDate(date!)
            
            cell.nameLabel.text = event.name
            cell.subtitleLabel.text = stringOfDateInNewFornat
            cell.dateLabel.text = event.format
            cell.descriptionNews.text = event.remark1
            if !event.remark2.isEmpty {
                cell.descriptionNews.text.appendContentsOf("\n\(event.remark2)")
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCellWithIdentifier(eventDetailCellIdentifier) as! EventDetailCell
        cell.event = event
        cell.delegate = self
        return cell
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
       
        if indexPath.row == 0 {
            return UITableViewAutomaticDimension
        }
        
        return detailCellHeight
    }
    
    //MARK: EventDetailCellDelegate
    
    func eventDetailCell(eventDetailCell: EventDetailCell, eventProgramPressed programBtn: UIButton) {
        
        openPDFWithURLString(event.file_detail, andFileName: event.name + "Program")
    }
    
    func eventDetailCell(eventDetailCell: EventDetailCell, eventTeeTimePressed programBtn: UIButton) {
        
        openPDFWithURLString(event.file_teetime, andFileName: event.name + "TeeTimes")
    }

    //MARK: UIDocumentInteractionControllerDelegate
    
    func documentInteractionControllerViewControllerForPreview(controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
    
    //MARK: Private methods
    
    func openPDFWithURLString(urlString : String, andFileName fileName: String) {
        
        let url = NSURL(string: urlString)
        
        if urlString.hasPrefix("http") {
            
            HUD.show(.LabeledProgress(title: "Downloading...", subtitle: nil))
            
            Downloader.load(url!, andFileName: fileName) { (filePath) in
                
                if  let path = filePath {
                    
                    dispatch_async(dispatch_get_main_queue(), {
                        HUD.hide(animated: false)
                    })
                    
                    self.showDocumentControllerWithURL(path)
                    self.event.file_result = path.URLString
                    NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
                    
                } else {
                    dispatch_async(dispatch_get_main_queue(), {
                        HUD.hide(animated: false)
                        HUD.flash(.Label(LocalisationDocument.sharedInstance.getStringWhinName("no_inet")), delay: 1.0, completion: nil)
                    })
                }
            }
            
        } else {
            self.showDocumentControllerWithURL(NSURL(string: event.file_result)!)
        }
    }
    
    func showDocumentControllerWithURL(path: NSURL) {
        
        self.documentInteractionController = UIDocumentInteractionController.init(URL:path)
        self.documentInteractionController?.delegate = self
        self.documentInteractionController?.presentPreviewAnimated(true)
        
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
        
        self.view.addSubview(popUpView)
        self.view.bringSubviewToFront(popUpView)
        
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
