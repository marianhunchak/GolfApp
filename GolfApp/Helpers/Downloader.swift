//
//  Downloader.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/25/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class Downloader {
    
    class func load(URL: NSURL, andFileName name: String, completion: ( NSURL?) -> Void ) {
        let sessionConfig = NSURLSessionConfiguration.defaultSessionConfiguration()
        let session = NSURLSession(configuration: sessionConfig, delegate: nil, delegateQueue: nil)
        let request = NSMutableURLRequest(URL: URL)
        request.HTTPMethod = "GET"
        
        let task = session.dataTaskWithRequest(request) { (data, response, error) in
            if (error == nil) {
                let statusCode = (response as! NSHTTPURLResponse).statusCode
                print("Success: \(statusCode)")
                
                var docURL = Global.docUrl
                
                docURL = docURL!.URLByAppendingPathComponent(name + ".pdf")
                
                //Lastly, write your file to the disk.
                data?.writeToURL(docURL!, atomically: true)
                completion(docURL)
            }
            else {
                print("Faulure: %@", error!.localizedDescription);
                completion(nil)
            }
        }
        
        task.resume()
    }
}