//
//  DetailCourseHeader.swift
//  GolfApp
//
//  Created by Admin on 11.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

protocol CourseHeaderDelegate {
    
    func tableCourseHeader(tableCourseHeader : ViewForDetailHeader ,button1Pressed button1 : AnyObject )
}

class ViewForDetailHeader: UIView {
    
    var delegate : CourseHeaderDelegate?
    var button1Available = false {
        didSet {
            if button1Available {
                button1.backgroundColor = Global.buttonOnColor
                button1.userInteractionEnabled = true
            }
        }
    }
    var button2Available = false
    var button3Available = false
    
    // MARK: - Connections outlet elements DetailCourseHeader
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuBarBackgrView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        
        button1.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("crs_the_course_btn"), forState: .Normal)
        button2.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("crs_facilities_btn"), forState: .Normal)
        button3.setTitle(LocalisationDocument.sharedInstance.getStringWhinName("crs_rates_btn"), forState: .Normal)

        button1.layer.cornerRadius = 5
        button2.layer.cornerRadius = 5
        button3.layer.cornerRadius = 5
        
        menuBarBackgrView.layer.cornerRadius = 5
        menuBarBackgrView.layer.borderWidth = 2
        menuBarBackgrView.layer.masksToBounds = true
        
        menuBarBackgrView.layer.borderColor = Global.menuBarStokeColor.CGColor
        menuBarBackgrView.backgroundColor = Global.menuBarBackgroundColor
        backgroundView.backgroundColor = UIColor.clearColor()
    }
    
    // MARK: - Connections action elements DetailCourseHeader
    
    @IBAction func button1Action(sender: AnyObject) {
        self.delegate?.tableCourseHeader(self, button1Pressed: sender)
    }
    
    @IBAction func button2Action(sender: AnyObject) {
    }
    
    @IBAction func button3Action(sender: AnyObject) {
    }
    
    static func loadViewFromNib() -> ViewForDetailHeader
    {
        let nib = UINib(nibName: "ViewForDetailHeader", bundle: nil)
        let header = nib.instantiateWithOwner(self, options: nil)[0] as! ViewForDetailHeader
        
        return header
    }
 
}
