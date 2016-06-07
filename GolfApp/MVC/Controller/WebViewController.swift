//
//  WebViewController.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/17/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class WebViewController: UIViewController, UIWebViewDelegate {

    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var webView: UIWebView!
    var url : NSURL?
    var theBool = true
    var myTimer = NSTimer()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.webView.delegate = self
        configureNavBar()
        
//        let testUrl = NSURL(string: "https://www.apple.com")
//        let req = NSURLRequest(URL: testUrl!)
//        self.webView.loadRequest(req)
        if let lUrl = url {
            let req = NSURLRequest(URL: lUrl)
            self.webView.loadRequest(req)
        }
        self.view.backgroundColor = Global.viewsBackgroundColor
        self.webView.backgroundColor = Global.viewsBackgroundColor
        
        self.progressView.progress = 0.0
        self.theBool = false
        self.myTimer = NSTimer.scheduledTimerWithTimeInterval(0.01667, target: self, selector: #selector(WebViewController.timerCallback), userInfo: nil, repeats: true)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func webViewDidStartLoad(webView: UIWebView) {
        
    }

    func webViewDidFinishLoad(webView: UIWebView) {
        self.theBool = true
    }

    func webView(webView: UIWebView, didFailLoadWithError error: NSError?) {
        
    }
    
    func timerCallback() {
        if self.theBool {
            if self.progressView.progress >= 1 {
                self.progressView.hidden = true
                self.myTimer.invalidate()
            } else {
                self.progressView.progress += 0.1
            }
        } else {
            self.progressView.progress += 0.05
            if self.progressView.progress >= 0.95 {
                self.progressView.progress = 0.95
            }
        }
    }

}
