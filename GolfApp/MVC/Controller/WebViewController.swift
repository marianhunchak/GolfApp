//
//  WebViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/17/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class WebViewController: BaseViewController {

    @IBOutlet weak var webView: UIWebView!
    var url : NSURL?

    override func viewDidLoad() {
        super.viewDidLoad()
        if let lUrl = url {
            let req = NSURLRequest(URL: lUrl)
            self.webView.loadRequest(req)
        }
        self.view.backgroundColor = Global.viewsBackgroundColor
        self.webView.backgroundColor = Global.viewsBackgroundColor

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
