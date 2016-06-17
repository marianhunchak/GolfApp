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
    func pressedButton2(tableCourseHeader : ViewForDetailHeader ,button2Pressed button2 : AnyObject )
    func pressedButton3(tableCourseHeader : ViewForDetailHeader ,button3Pressed button3 : AnyObject )
}

class ViewForDetailHeader: UIView {
    
    var delegate : CourseHeaderDelegate?

    // MARK: - Connections outlet elements DetailCourseHeader
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuBarBackgrView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    @IBOutlet weak var badgeLabel: SwiftBadge!


    override func awakeFromNib() {
        super.awakeFromNib()
 
        button1.layer.cornerRadius = 5
        button2.layer.cornerRadius = 5
        button3.layer.cornerRadius = 5
        
        menuBarBackgrView.layer.cornerRadius = 5
        menuBarBackgrView.layer.borderWidth = 2
        menuBarBackgrView.layer.masksToBounds = true
        
        menuBarBackgrView.layer.borderColor = Global.menuBarStokeColor.CGColor
        menuBarBackgrView.backgroundColor = Global.menuBarBackgroundColor
        backgroundView.backgroundColor = UIColor.clearColor()
        badgeLabel.hidden = true
    }
    
    // MARK: - Connections action elements DetailCourseHeader
    
    @IBAction func button1Action(sender: AnyObject) {
        self.delegate?.tableCourseHeader(self, button1Pressed: sender)
    }

    @IBAction func button2Action(sender: AnyObject) {
        self.delegate?.pressedButton2(self, button2Pressed: sender)
    }
    @IBAction func button3Action(sender: AnyObject) {
        self.delegate?.pressedButton3(self, button3Pressed: sender)
    }

    //MARK - Private methods
    static func loadViewFromNib() -> ViewForDetailHeader
    {
        let nib = UINib(nibName: "ViewForDetailHeader", bundle: nil)
        let header = nib.instantiateWithOwner(self, options: nil)[0] as! ViewForDetailHeader
        
        return header
    }
    
    func setButtonEnabled(button: UIButton, enabled: Bool) {
    
        if enabled {
            button.backgroundColor = Global.buttonOnColor
            button.userInteractionEnabled = true
        } else {
            button.backgroundColor = Global.buttonOffColor
            button.userInteractionEnabled = false
        }
    }
 
}
