//
//  ParcoursTableCell.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ParcoursTableCell: UITableViewCell {

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellItemLabel: UILabel!
    @IBOutlet weak var cellInfoLabel: UILabel!
    
    var course: Course! {
        didSet {
            self.cellItemLabel.text = self.course.name
            self.cellInfoLabel.text = self.course.holes + " trous - Par " + self.course.par + " - " + self.course.length + " " + self.course.length_unit
            
            if let imageDictionary = self.course.images.firstObject as? NSDictionary {
                let imageURL = NSURL(string: imageDictionary.objectForKey("url") as! String)!
                let imageName = imageDictionary.objectForKey("name") as! String
                NetworkManager.sharedInstance.getImageWhihURL(imageURL, imageName: imageName, completion: { (image) in
                    self.cellImage.image = image
                })
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.layer.cornerRadius = 5.0
        cellImage.layer.masksToBounds = true
    }
}
