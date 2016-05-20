//
//  News.swift
//  GolfApp
//
//  Created by Admin on 20.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class News {
    
    
    var id : Int?
    var title : String!
    var subtitle : String!
    var descr : String!
    var pubdate : String!
    var updated : String!
    var images = [Image]()
    
    static func newsWhithDictionary(pDictionary:NSDictionary) -> News {
        
        let lNews = News()
        lNews.title = pDictionary["title"] as? String ?? ""
        lNews.subtitle = pDictionary["subtitle"] as? String ?? ""
        lNews.id = pDictionary["id"] as? Int
        lNews.descr = pDictionary["descr"] as? String ?? ""
        lNews.pubdate = pDictionary["pubdate"] as? String ?? ""
        lNews.updated = pDictionary["updated"] as? String ?? ""
        
        for imageDict in pDictionary["images"] as! NSArray {
            lNews.images += [Image.imageWhithDictionary(imageDict as! NSDictionary)]
        }
        
        return lNews
    }
    
}