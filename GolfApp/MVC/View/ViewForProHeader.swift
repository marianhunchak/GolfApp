//
//  ViewForProHeader.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

protocol ProHeaderDelegate {

    func pressedButton2(tableProHeader : ViewForProHeader ,button2Pressed button2 : AnyObject )
    func pressedButton1(tableProHeader : ViewForProHeader ,button1Pressed button1 : AnyObject )
}

class ViewForProHeader: UIView {

    var delegate : ProHeaderDelegate?
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuBarBackgrView: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        
        button1.layer.cornerRadius = 5
        button2.layer.cornerRadius = 5
        menuBarBackgrView.layer.cornerRadius = 5
        menuBarBackgrView.layer.borderWidth = 2
        menuBarBackgrView.layer.masksToBounds = true
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
    
    
}
