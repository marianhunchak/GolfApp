//
//  ViewForProHeader.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

protocol ProHeaderDelegate {
    
    func pressedButton1(tableProHeader : ViewForProHeader ,button1Pressed button1 : AnyObject )
    func pressedButton2(tableProHeader : ViewForProHeader ,button2Pressed button2 : AnyObject )
}

class ViewForProHeader: UIView {

    var delegate : ProHeaderDelegate?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuBarBackgrView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var badgeLabel: SwiftBadge!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        
        button1.layer.cornerRadius = 5
        button2.layer.cornerRadius = 5
        menuBarBackgrView.layer.cornerRadius = 5
        menuBarBackgrView.layer.borderWidth = 2
        menuBarBackgrView.layer.masksToBounds = true
        
        toggleButtons(button1, btn2: button2)
        
        badgeLabel.insets =  CGSize(width: 2, height: 2)
        badgeLabel.center = CGPoint(x: 20, y: 20)
        self.bringSubviewToFront(badgeLabel)
        badgeLabel.hidden = true
    }
    
    @IBAction func button1Action(sender: AnyObject) {
    
        self.delegate?.pressedButton1(self, button1Pressed: sender)
    }
    
    @IBAction func button2Action(sender: AnyObject) {
        
        self.delegate?.pressedButton2(self, button2Pressed: sender)
    }
    
    //MARK - Private methods
    static func loadViewFromNib() -> ViewForProHeader
    {
        let nib = UINib(nibName: "ViewForProHeader", bundle: nil)
        let header = nib.instantiateWithOwner(self, options: nil)[0] as! ViewForProHeader
        
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
    
    func toggleButtons(btn1: UIButton, btn2: UIButton) {
        btn1.setHeaderButtonSelected()
        btn2.setHeaderButtonUnselected()
    }
    
    
}

extension UIButton {
    
    func setHeaderButtonSelected() {
        self.backgroundColor = Global.buttonOnColor
        self.userInteractionEnabled = false
    }
    
    func setHeaderButtonUnselected() {
        self.backgroundColor = Global.buttonOffColor
        self.userInteractionEnabled = true
    }
    
}
