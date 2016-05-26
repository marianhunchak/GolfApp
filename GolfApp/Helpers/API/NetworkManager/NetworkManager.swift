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

// numbers of items on one page
private let draw = 10

private let baseURL = "https://golfapp.ch/app_fe_dev/api/"
private let clientAndLanguage = "?client=\(Global.clientId)&language=\(Global.languageID)"

class NetworkManager {
    
    var jsonArray: NSDictionary?
    static let sharedInstance = NetworkManager()
    
    
    //MARK: Registering Device
    
    func registerDeviceWhithToken( tokenString: String, completion: (NSArray?, NSError?) -> Void)  {
        
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
                    NSUserDefaults.standardUserDefaults().synchronize()
                    print("JSON: \(JSON)")
                }
        }
    }
    
    func unregisterDevice() {
        
        let parameters = [
            "regid": "876",
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
            "regid": "874",
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
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/profile?client=22&language=\(Global.languageID)", parameters:nil )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSDictionary{
//                    print("JSON: \(JSON)")
                    let profileDictionary = JSON["profile"]! as! NSDictionary
                    let buttonsArray = JSON["buttons"]! as! [String]

                    let lProfile = Profile.profileWhithDictionary(profileDictionary, andArray: buttonsArray)
                    
                    completion(lProfile)

                }
        }
    }
    
    //MARK: Courses
    
    func getCours(completion: ([Course]?) -> Void) {
        Alamofire.request(.GET, "https://golfapp.ch/app_fe_dev/api/courses?client=22&language=\(Global.languageID)", parameters: nil)
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
    
    //MARK: Packages
    
    func getPackages(urlToPackage URL: String ,completion: ([Package]?) -> Void) {
        Alamofire.request(.GET, URL, parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    //   print("JSON: \(JSON)")
                    self.jsonArray = JSON as? NSDictionary
                    
                    let packageArray: NSArray = [self.jsonArray!["packages"]!]
                    var responseArray = [Package]()
                    
                    for packageDict in packageArray.firstObject as! NSArray {
                        responseArray.append(Package.itemWhithDictionary(packageDict as! NSDictionary))
                    }
                    
                    completion(responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK: Images
    
    // method for loading images whith URL ant your image name
    func getImageWhihURL(imageURL: NSURL, imageName: String, completion: (UIImage?) -> Void) -> Request? {
        
        if let image = HCCache.sharedCache.imageWithIdentifier(imageName) {
            completion(image)
            return nil
        } else {
            return Alamofire.request(.GET, imageURL)
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
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/pros?client=22&language=\(Global.languageID)", parameters: nil)
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
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/hotels?client=22&language=\(Global.languageID)", parameters: nil)
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
    
    //MARK: ProsShop
    
    func getProsShop(completion: ([ProsShop]?) -> Void) {
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/proshops?client=22&language=\(Global.languageID)", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    
                    let prosArray: NSArray = [self.jsonArray!["proshops"]!]
                    var responseArray = [ProsShop]()
                    
                    for courseDict in prosArray.firstObject as! NSArray {
                        responseArray.append(ProsShop.hotelsWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    //MARK: Restaurant
    
    func getRestaurant(completion: ([Restaurant]?) -> Void) {
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/restaurants?client=22&language=\(Global.languageID)", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    self.jsonArray = JSON as? NSDictionary
                    
                    let prosArray: NSArray = [self.jsonArray!["restaurants"]!]
                    var responseArray = [Restaurant]()
                    
                    for courseDict in prosArray.firstObject as! NSArray {
                        responseArray.append(Restaurant.restaurantWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK: Menu
    
    func getMenu(urlToRate URL: String ,completion: ([Rate]?) -> Void) {
        Alamofire.request(.GET, URL, parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    //   print("JSON: \(JSON)")
                    self.jsonArray = JSON as? NSDictionary
                    
                    let coursesArray: NSArray = [self.jsonArray!["menus"]!]
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
    
    //MARK: News
    
    func getNews(completion: ([News]?) -> Void) {
        Alamofire.request(.GET, "http://golfapp.ch/app_fe_dev/api/news?client=22&language=\(Global.languageID)", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    //   print("JSON: \(JSON)")
                    self.jsonArray = JSON as? NSDictionary
                    
                    let newsArray: NSArray = [self.jsonArray!["news"]!]
                    var responseArray = [News]()
                    
                    for newsDict in newsArray.firstObject as! NSArray {
                        responseArray.append(News.newsWhithDictionary(newsDict as! NSDictionary))
                    }
                    
                    completion(responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
    //MARK: Events
    
    func getEventsWithCategory(pCategory : String, completion: ([Event]?) -> Void) {
        
        let url =  baseURL + "events" + clientAndLanguage + "&category=\(pCategory)"
        
        var page = 1
        
        Alamofire.request(.GET, url + "&draw=\(draw)&page=\(page)", parameters: nil)
            .responseJSON { response in
              
                if let JSON = response.result.value as? NSDictionary{
                    
                    let eventsArray = JSON["events"] as! [AnyObject]

                    var responseArray = [Event]()
                    
                    for newsDict in eventsArray {
                        responseArray.append(Event.eventWithDict(newsDict as! [String : AnyObject]))
                    }
                    
                    completion(responseArray)
                }
                
        }

    }
    
    
}