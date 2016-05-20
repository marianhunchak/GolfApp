//
//  ViewForOffersHeader.swift
//  GolfApp
//
//  Created by Admin on 18.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

protocol OffersHeaderDelegate {
    
    func pressedButton1(tableOffersHeader : ViewForOffersHeader ,button1Pressed button1 : AnyObject )
}

class ViewForOffersHeader: UIView {

    var delegate : OffersHeaderDelegate?
    var textToShare = String()
    var urlToShare = String()
    
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var menuBarBackgrView: UIView!
    @IBOutlet weak var button1: UIButton!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundView.backgroundColor = Global.viewsBackgroundColor
        
        button1.layer.cornerRadius = 5

        
        menuBarBackgrView.layer.cornerRadius = 5
        menuBarBackgrView.layer.borderWidth = 2
        menuBarBackgrView.layer.masksToBounds = true
    }
    
    @IBAction func button1Action(sender: AnyObject) {
        
        self.delegate?.pressedButton1(self, button1Pressed: sender)
    }
    
    //MARK - Private methods
    static func loadViewFromNib() -> ViewForOffersHeader
    {
        let nib = UINib(nibName: "ViewForOffersHeader", bundle: nil)
        let header = nib.instantiateWithOwner(self, options: nil)[0] as! ViewForOffersHeader
        
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
