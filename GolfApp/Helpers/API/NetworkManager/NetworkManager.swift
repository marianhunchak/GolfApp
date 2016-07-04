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

private let baseURL = "http://golfapp.ch/app/api/"
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
        
        Alamofire.request(.POST, baseURL + "device/register", parameters:parameters )
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
            "regid": "961",
            "device_id": UIDevice.currentDevice().identifierForVendor!.UUIDString,
            ]
        Alamofire.request(.POST, baseURL + "device/unregister", parameters:parameters )
            .responseJSON { response in
                
                switch response.result {
                    
                    case .Success(let JSON):
                    print("Success with JSON: \(JSON)")
    //                            let response = JSON as! NSDictionary
            
                    case .Failure(let error):
                    print("Request failed with error: \(error)")
            
                    }

        }
    }
    
    // MARK: Notifications
    
    func getNotifications(completion: ([Notification]?, NSError?) -> Void)  {
        
        var parameters : [String : AnyObject]?
        
        if let regid = NSUserDefaults.standardUserDefaults().objectForKey("regid") as? NSNumber {
            parameters = [
                "regid": regid.stringValue
    //            "selector": "news,hotel,pro"
            ]
        }
        
        Alamofire.request(.POST, baseURL + "device/notifications", parameters:parameters )
            .responseJSON { response in
                
                switch response.result {
                    
                case .Success(let JSON):

//                    if let previousLanguageID = NSUserDefaults.standardUserDefaults().objectForKey("language") as? String {
//                    
//                        Notification.MR_deleteAllMatchingPredicate(NSPredicate(format: "language_id = %@", NSNumber(integer:Int(previousLanguageID)!) ))
//                        
//                    }
                    
                    NSUserDefaults.standardUserDefaults().setObject(Global.languageID, forKey: "language")
                    
                    NSUserDefaults.standardUserDefaults().synchronize()
                    
                    print("Success with JSON: \(JSON)")
                
                    var notificationArray = [Notification]()
                    
                    if let notifications = JSON["notifications"] as? [[String : AnyObject]] {
                        
                        for lNotificatioDict in notifications {
                            
                            notificationArray.append(Notification.notificationWithDictionary(lNotificatioDict))
                        }
                    }
                    completion(notificationArray, nil)
                    
                case .Failure(let error):
                    
                    print("Request failed with error: \(error)")
                    completion(nil, error)
                }
        }
    }

    
    func removeNotificationsWhithPostID(pId : String, sId : String ,completion: (NSError?)  -> Void) {
        var parameters : [String : AnyObject]?
        //var parameterDel : [String : AnyObject]?
        
        if let regid = NSUserDefaults.standardUserDefaults().objectForKey("regid") as? NSNumber {
            
            parameters = [
                "regid" : regid.stringValue,
                "device_id" : UIDevice.currentDevice().identifierForVendor!.UUIDString,
                "sid" : sId,
                "pid" : pId
            ]
        }

        
        Alamofire.request(.POST, baseURL + "device/notifications_remove", parameters:parameters )
            .responseJSON { response in
                
                switch response.result {
                    
                case .Success(let JSON):
                    
                        print("JSON: \(JSON)")
                    completion(nil)
                    
                case .Failure(let error):
                    
                    //DeleteNotification.notificationWithDictionary(parameterDel!)
                    
                    print("Request failed with error: \(error)")
                    completion(error)
                    
                    
            }
        }
    }
    
    
    //MARK: Profile & Advertising
    
    func getProfileAndAvertising(completion :Profile -> Void) {
        Alamofire.request(.GET, baseURL + "profile" + clientAndLanguage, parameters:nil )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSDictionary{
                    print("JSON: \(JSON)")
                    let profileDictionary = JSON["profile"]! as! NSDictionary
                    let buttonsArray = JSON["buttons"]! as! [String]

                    let lProfile = Profile.profileWhithDictionary(profileDictionary, andArray: buttonsArray)
                    
                    completion(lProfile)

                }
        }
    }
    
    //MARK: Courses
    
    func getCourseseWithPage( pPage: Int, completion: ([AnyObject]?, NSError?) -> Void) {
        Alamofire.request(.GET, baseURL + "courses" + clientAndLanguage, parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if pPage == 1 {
                        
                        let allEntity = Course.MR_findAllSortedBy("id", ascending: false) as! [Course]
                        for  courses in allEntity {
                            print(Course.MR_findAll().count)
                            courses.MR_deleteEntity()
                        }
                    }

                    
                    Course.MR_truncateAll()
                    self.jsonArray = JSON as? NSDictionary
                    
                    let coursesArray: NSArray = [self.jsonArray!["courses"]!]
                    var responseArray = [Course]()
                    
                    for courseDict in coursesArray.firstObject as! NSArray {
                        responseArray.append(Course.courseWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    completion(nil, response.result.error)
                }
        }
    }
    
    //MARK: Rate
    
    func getRate(urlToRate URL: String ,completion: ([Rate]?, NSError?) -> Void) {
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
                    
                    completion(responseArray, nil)
                    
                } else {
                    completion(nil, response.result.error)
                }
        }
    }
    
    //MARK: Menu
    
    func getMenu(urlToRate URL: String ,completion: ([Rate]?, NSError?) -> Void) {
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
                    
                    completion(responseArray , nil)
                    
                } else {
                    completion(nil, response.result.error)
                }
        }
    }
    
    //MARK: Packages
    
    func getPackages(urlToPackage URL: String ,completion: ([Package]?) -> Void) {
        Alamofire.request(.GET, URL, parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    //let allEntity = Package. as [Package]
                    self.jsonArray = JSON as? NSDictionary
                    
                    let packageArray: NSArray = [self.jsonArray!["packages"]!]
                    var responseArray = [Package]()
                    
                    for packageDict in packageArray.firstObject as! NSArray {
                        responseArray.append(Package.packageWhithDictionary(packageDict as! NSDictionary))
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
    
    func getProsWithPage( pPage: Int, completion: ([AnyObject]?, NSError?) -> Void) {
        
        let url =  baseURL + "pros" + clientAndLanguage
        
        Alamofire.request(.GET, url + "&draw=\(draw)&page=\(pPage)", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if  pPage == 1 {
                        let allEntity = Pros.MR_findAllSortedBy("id", ascending: false) as! [Pros]
                        for  pros in allEntity {
                            print(New.MR_findAll().count)
                            pros.MR_deleteEntity()
                        }
                    }
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let prosArray: NSArray = [self.jsonArray!["pros"]!]
                    var responseArray = [Pros]()
                    
                    for courseDict in prosArray.firstObject as! NSArray {
                        responseArray.append(Pros.prosWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    completion(nil, response.result.error)
                }
        }
    }
    
    //MARK: Hotels 
    
    func getHotelsWithPage( pPage: Int,completion: ([AnyObject]?, NSError?) -> Void) {
        
        let url =  baseURL + "hotels" + clientAndLanguage
        
        Alamofire.request(.GET, url + "&draw=\(draw)&page=\(pPage)", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if pPage == 1 {
                        
                        let allEntity = Hotel.MR_findAllSortedBy("id", ascending: false) as! [Hotel]
                        for  hotels in allEntity {
                            print(Hotel.MR_findAll().count)
                            hotels.MR_deleteEntity()
                        }
                    }

                    self.jsonArray = JSON as? NSDictionary
                    
                    let prosArray: NSArray = [self.jsonArray!["hotels"]!]
                    var responseArray = [Hotel]()
                    
                    for courseDict in prosArray.firstObject as! NSArray {
                        responseArray.append(Hotel.hotelsWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    completion(nil, response.result.error)
                }
        }
    }
    
    //MARK: ProsShop
    
    func getProsShop(pPage: Int,completion: ([AnyObject]?, NSError?) -> Void) {
        
        let url =  baseURL + "proshops" + clientAndLanguage
        
        Alamofire.request(.GET, url + "&draw=\(draw)&page=\(pPage)", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if pPage == 1 {
                        
                        let allEntity = ProsShop.MR_findAllSortedBy("id", ascending: false) as! [ProsShop]
                        for  prosShop in allEntity {
                            print(ProsShop.MR_findAll().count)
                            prosShop.MR_deleteEntity()
                        }
                        
                    }

                    self.jsonArray = JSON as? NSDictionary
                    
                    let prosArray: NSArray = [self.jsonArray!["proshops"]!]
                    var responseArray = [ProsShop]()
                    
                    for courseDict in prosArray.firstObject as! NSArray {
                        responseArray.append(ProsShop.hotelsWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    completion(nil, response.result.error)
                }
        }
    }
    //MARK: Restaurant
    
    func getRestaurant(pPage: Int,completion: ([AnyObject]?, NSError?) -> Void) {
        
        let url =  baseURL + "restaurants" + clientAndLanguage
        
        Alamofire.request(.GET, url + "&draw=\(draw)&page=\(pPage)", parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    
                    if pPage == 1 {
                        let allEntity = Restaurant.MR_findAllSortedBy("id", ascending: false) as! [Restaurant]
                        for  restaurants in allEntity {
                            print(Restaurant.MR_findAll().count)
                            restaurants.MR_deleteEntity()
                        }
                    }
                    
                    self.jsonArray = JSON as? NSDictionary
                    
                    let prosArray: NSArray = [self.jsonArray!["restaurants"]!]
                    var responseArray = [Restaurant]()
                    
                    for courseDict in prosArray.firstObject as! NSArray {
                        responseArray.append(Restaurant.restaurantWhithDictionary(courseDict as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    completion(nil, response.result.error)
                }
        }
    }
    
    //MARK: News
    
    func getNewsWithPage( pPage: Int, completion: ([AnyObject]?, NSError?) -> Void) {
        
        let url = baseURL + "news" + clientAndLanguage
        
        Alamofire.request(.GET, url + "&draw=\(draw)&page=\(pPage)" , parameters: nil)
            .responseJSON { response in
                
                
                
                if let JSON = response.result.value {
                    
                    if pPage == 1 {
                        let allEntity = New.MR_findAllSortedBy("updated_", ascending: false) as! [New]
                        for  new in allEntity {
                            
                            new.MR_deleteEntity()
                        }
                    }

                    self.jsonArray = JSON as? NSDictionary
                    
                    let newsArray: NSArray = [self.jsonArray!["news"]!]
                    var responseArray = [AnyObject]()
                    
                    for newsDict in newsArray.firstObject as! NSArray {
                        
                        responseArray.append(New.newsWhithDictionary(newsDict as! NSDictionary))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    completion(nil, response.result.error)
                }
        }
    }
    
    //MARK: Events
    
    func getEventsWithCategory(pCategory : String, andPage pPage : Int, completion: ([AnyObject]?, NSError?) -> Void) -> Request {
        
        let url =  baseURL + "events" + clientAndLanguage + "&category=\(pCategory)"
        
        return Alamofire.request(.GET, url + "&draw=\(draw)&page=\(pPage)", parameters: nil)
            .responseJSON { response in
              
                if let JSON = response.result.value as? NSDictionary {
                    
                    if pPage == 1 {
                        Event.MR_deleteAllMatchingPredicate(NSPredicate(format: "category = %@", pCategory))
                    }
                    
                    let eventsArray = JSON["events"] as! [AnyObject]

                    var responseArray = [AnyObject]()
                    
                    for newsDict in eventsArray {
                        responseArray.append(Event.eventWithDict(newsDict as! [String : AnyObject], andEventType: pCategory))
                    }
                    
                    completion(responseArray, nil)
                    
                } else {
                    
                completion(nil, response.result.error)
                    
                }
        }

    }
    //MARK: Suggestions
    
    func getSuggestions (urlToPackage URL: String ,completion: ([Package]?) -> Void) {
        Alamofire.request(.GET, URL, parameters: nil)
            .responseJSON { response in
                
                if let JSON = response.result.value {
                    //   print("JSON: \(JSON)")
                    self.jsonArray = JSON as? NSDictionary
                    
                    let packageArray: NSArray = [self.jsonArray!["suggestions"]!]
                    var responseArray = [Package]()
                    
                    for packageDict in packageArray.firstObject as! NSArray {
                        responseArray.append(Package.packageWhithDictionary(packageDict as! NSDictionary))
                    }
                    
                    completion(responseArray)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }

    //MARK: Advertisemet
    
    func getAdvertisemet(completion :Advertisemet -> Void) {
        Alamofire.request(.GET, baseURL + "profile" + clientAndLanguage, parameters:nil )
            .responseJSON { response in
                
                if let JSON = response.result.value as? NSDictionary{

                    let advertisemetDictionary = JSON["advertisemet"]! as! NSDictionary
                    
                    let lAdvertisemet = Advertisemet.advertisemetWhithDictionary(advertisemetDictionary)
                    
                    completion(lAdvertisemet)
                    
                } else {
                    print("Status cod = \(response.response?.statusCode)")
                }
        }
    }
    
}