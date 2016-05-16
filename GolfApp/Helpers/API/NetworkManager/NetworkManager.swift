//
//  NetworkManager.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


class NetworkManager {
    
    var jsonArray: NSDictionary?
    static let sharedInstance = NetworkManager()
    
    
    //MARK: Registering Device
    
    func registerDeviceWhithToken( tokenString: String, completion: (NSArray?, NSError?) -> Void)  {
        
        print(LocalisationDocument.sharedInstance.getStringWhinName("tt_book_tee_pop_up_title"))
        
        let parameters = [
            "device_token": tokenString,
            "device_id": UIDevice.currentDevice().identifierForVendor!.UUIDString,
            "device_os": "ios",
            "client": Global.clientId,
            "language": Global.languageID
        ]
        
        Alamofire.request(.POST, "https://golfapp.ch/app_fe_dev/api/device/register", parameters:parameters )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSDictionary{
                    NSUserDefaults.standardUserDefaults().setObject(JSON["regid"], forKey: "regid")
                    print("JSON: \(JSON)")
                }
        }
    }
    
    func unregisterDevice() {
        
        let parameters = [
            "regid": "616",
            "device_id": UIDevice.currentDevice().identifierForVendor!.UUIDString,
            ]
        Alamofire.request(.POST, "https://golfapp.ch/app_fe_dev/api/device/unregister", parameters:parameters )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSDictionary{
                    print("JSON: \(JSON)")
                }
        }
    }
    
    //MARK: Profile & Advertising
    
    func getProfileAndAvertising(completion :Profile -> Void) {
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/profile?client=22&language=1", parameters:nil )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSDictionary{
                    print("JSON: \(JSON)")
                    let profileDictionary = JSON["profile"]! as! NSDictionary

                    let lProfile = Profile.profileWhithDictionary(profileDictionary)
                    
                    completion(lProfile)

                }
        }
    }
    
    //MARK: Courses
    
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
    
    //MARK: Rate
    
    func getRate(urlToRate URL: String ,completion: ([Rate]?) -> Void) {
        Alamofire.request(.GET, URL, parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                                     //   print("JSON: \(JSON)")
                    self.jsonArray = JSON as? NSDictionary
                    
                    let coursesArray: NSArray = [self.jsonArray!["rates"]!]
                    var responseArray = [Rate]()
                    
                    for rateDict in coursesArray.firstObject as! NSArray {
                        responseArray.append(Rate.rateWhithDictionary(rateDict as! NSDictionary))
                    }
                    
                    completion(responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK: Images
    
    // method for loading images whith URL ant your image name
    func getImageWhihURL(imageURL: NSURL, imageName: String, completion: (UIImage?) -> Void) {
        
        if let image = HCCache.sharedCache.imageWithIdentifier(imageName) {
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