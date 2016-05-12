//
//  NetworkManager.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import Alamofire
//import SwiftyJSON

class NetworkManager {
    
    var jsonArray: NSDictionary?
    static let sharedInstance = NetworkManager()
    
    func getCours(completion: ([Course]?) -> Void) {
        Alamofire.request(.GET, "https://golfapp.ch/app_fe_dev/api/courses?client=22&language=1", parameters: nil)
            .responseJSON { response in
           
                if let JSON = response.result.value {
//                    print("JSON: \(JSON)")
                    self.jsonArray = JSON as? NSDictionary
                    
                    let coursesArray: NSArray = [self.jsonArray!["courses"]!]
                    var responseArray = [Course]()
                    
                    for courseDict in coursesArray.firstObject as! NSArray {
                        responseArray.append(Course.courseWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray)

                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    func getImageWhihURL(imageURL: NSURL, imageName: String, completion: (UIImage?) -> Void) {
        
        if let image = HCCache.sharedCache.imageWithIdentifier(imageName){
            completion(image)
        } else {
            
            completion(nil)
            
            Alamofire.request(.GET, imageURL)
                .responseImage { response in
                    
                    if let image = response.result.value {
                        HCCache.sharedCache.addImage(image, withIdentifier: imageName)
                        completion(image)
                    }
            }
        }
    }
    
    
    
    
}