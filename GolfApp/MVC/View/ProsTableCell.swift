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
    }
    
    override func prepareForReuse() {
        self.prosImage.image = UIImage(named: "a_place_holder_list_view")
        if request != nil {
            request!.cancel()
        }
    }
    
}
