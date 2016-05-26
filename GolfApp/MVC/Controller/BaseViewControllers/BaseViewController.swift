//
//  BaseViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/13/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var refreshControl:UIRefreshControl!
    
    override func viewDidLoad()  {
        super.viewDidLoad()
        self.configureNavBar()
        
        tableView.backgroundColor = Global.viewsBackgroundColor
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action:#selector(refresh(_:)), forControlEvents: UIControlEvents.ValueChanged)
        tableView.addSubview(refreshControl)
    }
    
    func refresh(sender:AnyObject) {

        self.tableView.reloadData()
        self.performSelector(#selector(endRefresh), withObject: nil, afterDelay: 1)
        
    }
    
    func endRefresh() {
        refreshControl!.endRefreshing()
    }

}


// Extension for configuration navigation bar on all controllers

extension UIViewController {
    
    func configureNavBar() {
        self.navigationController?.navigationBar.hidden = false;
        self.navigationController?.navigationBar.barTintColor = Global.navigationBarColor
        
        let homeButton = UIBarButtonItem.init(image:UIImage(named:"a_home_icon"),
                                              style: .Plain,
                                              target: self,
                                              action: #selector(showMainController))
        homeButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        self.navigationItem.rightBarButtonItem = homeButton
        
        let backButton = UIBarButtonItem.init(image:UIImage(named:"a_back_btn"),
                                              style: .Plain,
                                              target: self,
                                              action: #selector(showPreviousController))
        backButton.imageInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        
        let negativeSpacer = UIBarButtonItem.init(barButtonSystemItem: .FixedSpace, target: self, action: nil)
        negativeSpacer.width = -10
        
        self.navigationItem.leftBarButtonItems = [negativeSpacer, backButton]
        
        let textAtributes = [ NSFontAttributeName: UIFont(name: "StoneInformal LT Semibold", size: 18)!,
                                                   NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        self.navigationController!.navigationBar.titleTextAttributes = textAtributes
    }
    
    //MARK: Actions
    
    func showMainController() {
        self.navigationController?.popToRootViewControllerAnimated(false)
    }
    
    func showPreviousController() {
        self.navigationController?.popViewControllerAnimated(false)
    }
    //MARK: LABEL
//    func showOfflineModeLabel() {
//        
//        let foregroundView = UILabel(frame: CGRectMake(0, view.frame.maxY - 50, 200, 40))
//        foregroundView.center.x = (UIApplication.sharedApplication().keyWindow?.center.x)!
//        foregroundView.alpha = 0.0
//        foregroundView.layer.cornerRadius = 20
//        foregroundView.layer.masksToBounds = true
//        foregroundView.text = LocalisationDocument.sharedInstance.getStringWhinName("no_inet")
//        foregroundView.textAlignment = .Center
//        foregroundView.backgroundColor = Global.navigationBarColor
//        foregroundView.textColor = UIColor.whiteColor()
//        foregroundView.font = UIFont(name: "StoneInformal LT Semibold", size: 18)!
//        
//        UIView.animateWithDuration(0.5) {
//            self.navigationController!.view.addSubview(foregroundView)
//            foregroundView.alpha = 0.9
//        }
//        
//        self.performSelector(#selector(hideOfflineModeLabel(_:)), withObject:foregroundView, afterDelay:2)
//    }
//    
//    func hideOfflineModeLabel(label : UILabel) {
//        
//        UIView.animateWithDuration(0.5, animations: {
//            label.alpha = 0.0  })
//        { (finished) in
//            if finished {
//                label.removeFromSuperview()
//            }
//        }
//    }
    
   
}
