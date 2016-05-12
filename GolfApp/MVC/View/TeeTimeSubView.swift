//
//  TeeTimeSubView.swift
//  GolfApp
//
//  Created by Admin on 12.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class TeeTimeSubView : UIView {
    
    
    @IBOutlet weak var email: UIButton!
    
    @IBOutlet weak var telephone: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var teeTimeBackgroundView: UIView!
    
    @IBAction func emailButton(sender: AnyObject) {
    }
    @IBAction func telephoneButton(sender: AnyObject) {
    }
    @IBAction func cancelButton(sender: AnyObject) {
        
        self.removeFromSuperview()
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        email.layer.cornerRadius = 5
        telephone.layer.cornerRadius = 5
        cancel.layer.cornerRadius = 5
        teeTimeBackgroundView.layer.cornerRadius = 5
        
        email.layer.borderWidth = 2
        email.layer.borderColor = UIColor.whiteColor().CGColor
        
        telephone.layer.borderWidth = 2
        telephone.layer.borderColor = UIColor.whiteColor().CGColor
        
        cancel.layer.borderWidth = 2
        cancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        teeTimeBackgroundView.layer.borderWidth = 2
        teeTimeBackgroundView.layer.borderColor = UIColor.blackColor().CGColor
        
    }
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    static func loadViewFromNib() -> TeeTimeSubView
    {
        let nib = UINib(nibName: "TeeTimeSubView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! TeeTimeSubView
        
        return view
    }
    
    
}
