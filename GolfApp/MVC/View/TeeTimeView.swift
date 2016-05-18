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
        print(emailString)
        if MFMailComposeViewController.canSendMail() {
            
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([emailString!])

            
            UIApplication.sharedApplication().keyWindow?.rootViewController?.presentViewController(mail, animated: true, completion: nil)
        } else {
            
            let sendMailErrorAlert = UIAlertView(title: "GolfApp not send Email", message: "Problen with sending Email.Please check e-mail configuration and try again", delegate: self, cancelButtonTitle: "ok")
            sendMailErrorAlert.show()
        }
        
    }
    @IBAction func telephoneButton(sender: AnyObject) {
             print(phoneString)
             UIApplication.sharedApplication().openURL(NSURL(string:"tel://" + phoneString!)!)
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
