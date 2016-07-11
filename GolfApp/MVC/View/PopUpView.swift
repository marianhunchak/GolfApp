//
//  PopUpView.swift
//  GolfApp
//
//  Created by Admin on 03.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class PopUpView: UIView {

    let defaults : NSUserDefaults = NSUserDefaults.standardUserDefaults()

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popUpImage: UIImageView!

    @IBOutlet weak var imageViewContainer: UIView!
    @IBOutlet weak var imageViewContainerHeight: NSLayoutConstraint!
    @IBOutlet weak var imageViewContainerWidth: NSLayoutConstraint!

    var websiteUrl : String!
    
    var poupImage : Image! {
        
        didSet {

            NetworkManager.sharedInstance.getImageWhihURL(NSURL(string: poupImage.url!)!, imageName: poupImage.name!, completion: {
                (image) in
                
                if let lImage = image {
                    
                    self.popUpImage.image = lImage
//                    self.popUpImage.image = UIImage(named: "a_place_holder_list_view-1")
//                    print("image size = \(self.popUpImage.image?.size)")
                    self.imageViewContainerWidth.constant = self.popUpImage.image!.size.width * 0.8
                    self.imageViewContainerHeight.constant = self.imageViewContainer.frame.size.width / (self.popUpImage.image!.size.width * 0.8) * self.popUpImage.image!.size.height
                    
                    UIView.animateWithDuration(0.25, animations: { 
                        self.hidden = false
                        self.popUpImage.hidden = false
                    })
               }
            })
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.hidden = true
        popUpImage.hidden = true
        popUpImage.contentMode = UIViewContentMode.ScaleAspectFill
        popUpImage.clipsToBounds = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        self.popUpImage.addGestureRecognizer(tapGesture)
    }
    

    @IBAction func closePopupView(sender: AnyObject) {
        
        defaults.removeObjectForKey("lastLoadDate")
        self.popUpImage.removeFromSuperview()
        self.removeFromSuperview()
        
        
    }

    func handleTapGesture(sender: UITapGestureRecognizer) {
        
        self.popUpImage.removeFromSuperview()
        self.removeFromSuperview()
        UIApplication.sharedApplication().openURL(NSURL(string: websiteUrl)!)
    }
    
    
    static func loadViewFromNib() -> PopUpView
    {
        let nib = UINib(nibName: "PopUpView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! PopUpView
        return view
    }
}
