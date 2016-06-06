//
//  PopUpView.swift
//  GolfApp
//
//  Created by Admin on 03.06.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class PopUpView: UIView {

    

    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var shadowView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var popUpImage: UIImageView!

    @IBOutlet weak var imageViewContainerHeight: NSLayoutConstraint!

    var websiteUrl : String!
    
    var poupImage : Image! {
        
        didSet {

            NetworkManager.sharedInstance.getImageWhihURL(NSURL(string: poupImage.url!)!, imageName: poupImage.name!, completion: {
                (image) in
                
                if let lImage = image {
                    dispatch_async(dispatch_get_main_queue(), { 
                        self.popUpImage.image = lImage
//                        self.popUpImage.image = UIImage(named: "a_splash")
                        self.imageViewContainerHeight.constant = self.popUpImage.frame.size.width / self.popUpImage.image!.size.width * self.popUpImage.image!.size.height
                    })
               }
            })
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        popUpImage.contentMode = UIViewContentMode.ScaleAspectFit
        popUpImage.clipsToBounds = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTapGesture(_:)))
        self.popUpImage.addGestureRecognizer(tapGesture)

    }
    

    @IBAction func closePopupView(sender: AnyObject) {
        
        self.removeFromSuperview()
        
    }

    func handleTapGesture(sender: UITapGestureRecognizer) {
        
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
