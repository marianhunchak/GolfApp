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

class CoursTableCell: UITableViewCell {
    
    // MARK: - Connections outlet elements

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellItemLabel: UILabel!
    @IBOutlet weak var cellInfoLabel: UILabel!
    
    //MARK: Constraints
    
    @IBOutlet weak var cellInfoLabelHeight: NSLayoutConstraint!
    
    var imageForCell: Image? {
        didSet {
            if let lImage = imageForCell {
                NetworkManager.sharedInstance.getImageWhihURL(NSURL(string: lImage.url!)! , imageName: lImage.name!, completion: {
                    (image) in
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
