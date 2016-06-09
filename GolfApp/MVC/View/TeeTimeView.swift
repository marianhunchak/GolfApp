//
//  TeeTimeSubView.swift
//  GolfApp
//
//  Created by Admin on 12.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit
import MessageUI

class TeeTimeView : UIView , MFMailComposeViewControllerDelegate{
    
    // MARK: - Variables
    
    var phoneString: String?
    var emailString: String?
    
   // MARK: - Connections outlet elements
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var email: UIButton!
    @IBOutlet weak var telephone: UIButton!
    @IBOutlet weak var cancel: UIButton!
    @IBOutlet weak var teeTimeBackgroundView: UIView!
    
    // MARK: - Connections action elements
    
    @IBAction func emailButton(sender: AnyObject) {
        if let email = emailString {
            
            if MFMailComposeViewController.canSendMail() {
                
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setToRecipients([email])
                
                UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(mail, animated: true, completion: nil)
            } else {
                
                let sendMailErrorAlert = UIAlertView(title: "No Mail Accounts", message: "Please set up Mail account in order to send email.", delegate: self, cancelButtonTitle: "ok")
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
            
            let sendMailErrorAlert = UIAlertView(title: "GolfApp can not make a call!", message: "GolfApp can not call because there is no phone number!", delegate: self, cancelButtonTitle: "ok")
            sendMailErrorAlert.show()
        }
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
        
        teeTimeBackgroundView.backgroundColor = Global.menuBarBackgroundColor
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cancelButton(_:)))
        self.addGestureRecognizer(tapGesture)
    }
    
    //MARK: Private methods

    static func loadViewFromNib() -> TeeTimeView
    {
        let nib = UINib(nibName: "TeeTimeView", bundle: nil)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! TeeTimeView
        
        view.title.text = LocalisationDocument.sharedInstance.getStringWhinName("tt_book_tee_pop_up_title")
        view.email.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("email_button_btn"), forState: .Normal)
        view.telephone.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("tt_phone_btn"), forState: .Normal)
        view.cancel.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("tt_cancel_btn"), forState: .Normal)

        return view
    }
    func mailComposeController(controller: MFMailComposeViewController, didFinishWithResult result: MFMailComposeResult, error: NSError?) {
        controller.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
