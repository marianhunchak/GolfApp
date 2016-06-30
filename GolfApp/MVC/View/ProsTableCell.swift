//
//  ProsTableCell.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//
import UIKit
import Alamofire

class ProsTableCell: UITableViewCell {
    
    
    @IBOutlet weak var prosImage: UIImageView!
    @IBOutlet weak var prosLabel: UILabel!
    @IBOutlet weak var badgeLabel: SwiftBadge!
    
    var request: Request?
    
    var imageForCell: Image? {
        didSet {
            if let lImage = imageForCell {
                
                if let storedImage = UIImage(contentsOfFile: ImageSaver.fileInDocumentsDirectory(lImage.name)) {
                    self.prosImage.image = storedImage
                    
                } else {
                    
                    request?.cancel()
                    request = NetworkManager.sharedInstance.getImageWhihURL(NSURL(string: lImage.url!)! , imageName: lImage.name!, completion: {
                        (image) in
                        if let lResponseImage = image {
                            self.prosImage.image = lResponseImage
                            ImageSaver.saveImage(lResponseImage, name: lImage.name)
                        }
                    })
                }
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prosImage.layer.cornerRadius = 5.0
        prosImage.layer.masksToBounds = true
        
        badgeLabel.insets =  CGSize(width: 2, height: 2)
        badgeLabel.center = CGPoint(x: 20, y: 20)
        self.bringSubviewToFront(badgeLabel)
        badgeLabel.hidden = true
    }
    
    override func prepareForReuse() {
        self.prosImage.image = UIImage(named: "a_place_holder_list_view-1")
        if request != nil {
            request!.cancel()
        }
    }
    
}
