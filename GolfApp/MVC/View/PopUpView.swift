//
//  PopUpView.swift
//  GolfApp
//
//  Created by Admin on 03.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class PopUpView: UIView {

    
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popUpImage: UIImageView!
    var websiteUrl : String!
    
    var poupImage : Image! {
        
        didSet {

            NetworkManager.sharedInstance.getImageWhihURL(NSURL(string: poupImage.url!)!, imageName: poupImage.name!, completion: {
                (image) in
                
                if let lImage = image {
                    self.popUpImage.image = lImage
                }
            })
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        popUpImage.contentMode = UIViewContentMode.ScaleAspectFill
        popUpImage.clipsToBounds = true

    }
    

    @IBAction func closePopupView(sender: AnyObject) {
        
        self.removeFromSuperview()
        
    }
    
    @IBAction func showUrl(sender: AnyObject) {
        
     UIApplication.sharedApplication().openURL(NSURL(string: websiteUrl)!)

        
    }
    
    
    static func loadViewFromNib() -> PopUpView
    {
        let nib = UINib(nibName: "PopUpView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! PopUpView
        return view
    }
}
