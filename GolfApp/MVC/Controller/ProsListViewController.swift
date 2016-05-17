//
//  ProsListViewController.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class ProsListViewController: UIViewController {

    var prosArray = [Pros]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NetworkManager.sharedInstance.getPros { array in
            self.prosArray = array!
            print("<<<<\(self.prosArray)>>>>")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
 
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
