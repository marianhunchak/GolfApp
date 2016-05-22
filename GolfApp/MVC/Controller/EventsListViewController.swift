//
//  EventsListViewController.swift
//  GolfApp
//
//  Created by Admin on 20.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class EventsListViewController: BaseViewController , ProHeaderDelegate {
    
    var eventsPast = [Events]()
    var eventsFuture = [Events]()
    let viewForHead = ViewForProHeader.loadViewFromNib()
    
    @IBOutlet weak var headerView: UIView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupHeaderView()
        
        self.navigationItem.title = LocalisationDocument.sharedInstance.getStringWhinName("evt_list_view_nav_bar")
        self.tableView.backgroundColor = Global.viewsBackgroundColor
        self.headerView.backgroundColor = Global.viewsBackgroundColor

        NetworkManager.sharedInstance.getEventsPast { (eEvents) in
            self.eventsPast = eEvents!
            print("<<<<<\(self.eventsPast.count)>>>>>")
        }
        NetworkManager.sharedInstance.getEventsFuture { (eEvents) in
            self.eventsFuture = eEvents!
            print("<<<<<\(self.eventsFuture.count)>>>>>")
        }
    }

    //MARK: Private methods
    func setupHeaderView() {
       // let viewForHead = ViewForProHeader.loadViewFromNib()
        viewForHead.frame = CGRectMake(0.0, 0.0, (UIApplication.sharedApplication().keyWindow?.frame.size.width)!, headerView.frame.size.height)
        headerView.addSubview(viewForHead)
        
        viewForHead.button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("evt_upcoming_event_btn"), forState: .Normal)
        viewForHead.button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("evt_pastevent_btn"), forState: .Normal)
        
        viewForHead.setButtonEnabled(viewForHead.button1, enabled: true)
        viewForHead.setButtonEnabled(viewForHead.button2, enabled: true)
        viewForHead.button2.backgroundColor = Global.buttonOffColor
        viewForHead.delegate = self
    }
    func pressedButton2(tableCourseHeader: ViewForProHeader, button2Pressed button2: AnyObject) {
        
        print("Button 2 presed")
        viewForHead.button1.backgroundColor = Global.buttonOffColor
        viewForHead.button2.backgroundColor = Global.buttonOnColor
    }
    
    func pressedButton1(tableProHeader: ViewForProHeader, button1Pressed button1: AnyObject) {
        
        print("Button 1 presed")
        viewForHead.button2.backgroundColor = Global.buttonOffColor
        viewForHead.button1.backgroundColor = Global.buttonOnColor
       
    }
}
