//
//  BaseTableViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/13/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class BaseTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationController?.navigationBar.barTintColor = Global.navigationBarColor
        let homeButton = UIBarButtonItem.init(title: "Home", style:.Plain, target: self, action: #selector(showMainController))
        self.navigationItem.rightBarButtonItem = homeButton
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func showMainController() {
        self.navigationController?.popToRootViewControllerAnimated(true)
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
