//
//  ContactSubView.swift
//  GolfApp
//
//  Created by Admin on 10.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import MessageUI

class ContactView: UIView , MFMailComposeViewControllerDelegate{
    
    // MARK: - Variables
    
    var phoneString: String?
    var emailString: String?
    var longitude: String?
    var latitude: String?
    
    
    // MARK: - Connections outlet elements
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var telephone: UIButton!
    @IBOutlet weak var navigation: UIButton!
    @IBOutlet weak var cancel: UIButton!    
    @IBOutlet weak var contactBackgroundView: UIView!
    
    // MARK: - Connections action elements
    
    @IBAction func emailButton(sender: AnyObject) {
        
        if let email = emailString {
            
            if MFMailComposeViewController.canSendMail() {
                
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([email])
                
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(mail, animated: true, completion: nil)
            } else {
                
                let sendMailErrorAlert = UIAlertView(title: "No Mail Accounts", message: "Please set up Mail account in order to send email.", delegate: self, cancelButtonTitle: "Ok")
                sendMailErrorAlert.show()
            }
        } else {
            let sendMailErrorAlert = UIAlertView(title: "No Mail address!", message: "GolfApp can not send Mail because there is no address!", delegate: self, cancelButtonTitle: "ok")
            sendMailErrorAlert.show()
        }
    }
    
    @IBAction func telephoneButton(sender: AnyObject) {
        
        if let phone = phoneString {
                UIApplication.sharedApplication().openURL(NSURL(string:"telprompt://" + phone)!)
        } else {
        
            let callErrorAlert = UIAlertView(title: "GolfApp can not make a call!", message: "GolfApp can not call because there is no phone number!", delegate: self, cancelButtonTitle: "Ok")
            callErrorAlert.show()
        }
    }
    
    @IBAction func navigationButton(sender: AnyObject) {
        
        if longitude != "" && latitude != "" {
        
            if (UIApplication.sharedApplication().canOpenURL(NSURL(string:"comgooglemaps://")!)) {
                UIApplication.sharedApplication().openURL(NSURL(string:
                    "comgooglemaps://?saddr=&daddr=\(latitude ?? ""),\(longitude ?? "")&directionsmode=driving")!)
                
            } else {
                UIApplication.sharedApplication().openURL(NSURL(string: "https://itunes.apple.com/in/app/google-maps-real-time-navigation/id585027354?mt=8")!)
            }
        }else {
        
            let callErrorAlert = UIAlertView(title: "GolfApp can not display the map!", message: "GolfApp can not display the map because no coordinates!", delegate: self, cancelButtonTitle: "Ok")
            callErrorAlert.show()
        
        }
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
        contactBackgroundView.backgroundColor = Global.menuBarBackgroundColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButton(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    static func loadViewFromNib() -> ContactView
    {
        let nib = UINib(nibName: "ContactView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! ContactView
        
        view.title.text = LocalisationDocument.sharedInstance.getStringWhinName("cnt_contact_pop_up_title")
        view.email.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("cnt_email_btn"), forState: .Normal)
        view.telephone.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("cnt_phone_btn"), forState: .Normal)
        view.navigation.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("cnt_direction_btn"), forState: .Normal)
        view.cancel.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("cnt_cancel_btn"), forState: .Normal)
        
        return view
    }
    
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }


}
