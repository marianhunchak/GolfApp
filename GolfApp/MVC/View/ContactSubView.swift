//
//  ContactSubView.swift
//  GolfApp
//
//  Created by Admin on 10.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import MessageUI

class ContactSubView: UIView , MFMailComposeViewControllerDelegate{
    
    var profile: Profile?
    
    @IBOutlet weak var email: UIButton!
    
    @IBOutlet weak var telephone: UIButton!
    
    @IBOutlet weak var navigation: UIButton!
    
    @IBOutlet weak var cancel: UIButton!
    
    @IBOutlet weak var contactBackgroundView: UIView!
    
    @IBAction func emailButton(sender: AnyObject) {
        
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            if let lProfile = profile {
            mail.setToRecipients([lProfile.email])
            }
//            mail.setMessageBody("<p>You're so awesome!</p>", isHTML: true)
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(mail, animated: true, completion: nil)
        } else {
            // show failure alert
        }
    }
    @IBAction func telephoneButton(sender: AnyObject) {
        
        if let lProfile = profile {
            print(lProfile.phone)
        UIApplication.sharedApplication().openURL(NSURL(string:"tel://" + lProfile.phone)!)
        }
//        let installed = UIApplication.sharedApplication().canOpenURL(NSURL(string: "skype:")!)
//        if installed {
//            UIApplication.sharedApplication().openURL(NSURL(string: "skype:echo123?call")!)
//        } else {
//            UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/in/app/skype/id304878510?mt=8")!)
//        }
    }
    @IBAction func navigationButton(sender: AnyObject) {
    }
    @IBAction func cancelButton(sender: AnyObject) {
        
        self.removeFromSuperview()
        
    }

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        email.layer.cornerRadius = 5
        telephone.layer.cornerRadius = 5
        navigation.layer.cornerRadius = 5
        cancel.layer.cornerRadius = 5
        contactBackgroundView.layer.cornerRadius = 5
        
        email.layer.borderWidth = 2
        email.layer.borderColor = UIColor.whiteColor().CGColor
        
        telephone.layer.borderWidth = 2
        telephone.layer.borderColor = UIColor.whiteColor().CGColor
        
        navigation.layer.borderWidth = 2
        navigation.layer.borderColor = UIColor.whiteColor().CGColor
        
        cancel.layer.borderWidth = 2
        cancel.layer.borderColor = UIColor.whiteColor().CGColor
        
        contactBackgroundView.layer.borderWidth = 2
        contactBackgroundView.layer.borderColor = UIColor.blackColor().CGColor

    }

    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    static func loadViewFromNib() -> ContactSubView
    {
        let nib = UINib(nibName: "ContactSubView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! ContactSubView
        
        return view
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }


}
