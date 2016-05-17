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
        
        let parameters = [
            "device_token": tokenString,
            "device_id": UIDevice.currentDevice().identifierForVendor!,
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
            "regid": "641",
            "device_id": UIDevice.currentDevice().identifierForVendor!.UUIDString,
            ]
        Alamofire.request(.POST, "https://golfapp.ch/app_fe_dev/api/device/unregister", parameters:parameters )
            .responseJSON {
                response in switch response.result {
                    
                            case .Success(let JSON):
                            print("Success with JSON: \(JSON)")
//                            let response = JSON as! NSDictionary
                    
                            case .Failure(let error):
                            print("Request failed with error: \(error)")
                    
                            }

        }
    }
    
    func getNotifications(completion: (NSArray?, NSError?) -> Void)  {
        
        let parameters = [
            "regid": "650",
            "selector": "news"
        ]
        
        Alamofire.request(.POST, "http://golfapp.ch/app_fe_dev/api/device/notifications", parameters:parameters )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSDictionary{
                    NSUserDefaults.standardUserDefaults().setObject(JSON["regid"], forKey: "regid")
                    print("JSON: \(JSON)")
                }
        }
    }
    
    
    //MARK: Profile & Advertising
    
    func getProfileAndAvertising(completion :Profile -> Void) {
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/profile?client=22&language=1", parameters:nil )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSDictionary{
//                    print("JSON: \(JSON)")
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
            Alamofire.request(.GET, imageURL)
                .responseImage { response in
                    
                    if let image = response.result.value {
                        HCCache.sharedCache.addImage(image, withIdentifier: imageName)
                        completion(image)
                    }
            }
        }
    }
    
    //MARK: Pros
    
    func getPros(completion: ([Pros]?) -> Void) {
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/pros?client=22&language=1", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    //                    print("JSON: \(JSON)")
                    self.jsonArray = JSON as? NSDictionary
                    
                    let prosArray: NSArray = [self.jsonArray!["pros"]!]
                    var responseArray = [Pros]()
                    
                    for courseDict in prosArray.firstObject as! NSArray {
                        responseArray.append(Pros.prosWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK: Hotels 
    
    func getHotels(completion: ([Hotel]?) -> Void) {
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/hotels?client=22&language=1", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    
                    let prosArray: NSArray = [self.jsonArray!["hotels"]!]
                    var responseArray = [Hotel]()
                    
                    for courseDict in prosArray.firstObject as! NSArray {
                        responseArray.append(Hotel.hotelsWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }

    
}