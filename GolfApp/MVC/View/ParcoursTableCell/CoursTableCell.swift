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
import MagicalRecord

class CoursTableCell: UITableViewCell {
    
    // MARK: - Connections outlet elements

    @IBOutlet weak var cellImage: UIImageView!
    @IBOutlet weak var cellItemLabel: UILabel!
    @IBOutlet weak var cellInfoLabel: UILabel!
    @IBOutlet weak var badgeLabel: SwiftBadge!
    
    var request: Request?
    
    //MARK: Constraints
    
    @IBOutlet weak var cellInfoLabelHeight: NSLayoutConstraint!
    
    var imageForCell: Image? {
        
        didSet {
            if let lImage = imageForCell {
                
                if let storedImage = UIImage(contentsOfFile: ImageSaver.fileInDocumentsDirectory(lImage.name)) {
                    self.cellImage.image = storedImage
                    
                } else {
                    
                    request?.cancel()
                    request = NetworkManager.sharedInstance.getImageWhihURL(NSURL(string: lImage.url!)! , imageName: lImage.name!, completion: {
                        (image) in
                        if let lResponseImage = image {
                            self.cellImage.image = lResponseImage
                            ImageSaver.saveImage(lResponseImage, name: lImage.name)
                        }
                    })
                }
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImage.layer.cornerRadius = 5.0
        cellImage.layer.masksToBounds = true
        
        self.bringSubviewToFront(badgeLabel)
        badgeLabel.hidden = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.cellImage.image = UIImage(named: "a_place_holder_list_view")
        if request != nil {
            request!.cancel()
        }
    }
    
}
