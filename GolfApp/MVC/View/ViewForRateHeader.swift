//
//  ViewForRateHeader.swift
//  GolfApp
//
//  Created by Admin on 16.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class ViewForRateHeader: UIView {
    
    @IBOutlet weak var textLabeForRateHeader: UILabel!
    @IBOutlet weak var backgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        self.backgroundColor = Global.navigationBarColor
        self.backgroundView.backgroundColor = Global.navigationBarColor
        textLabeForRateHeader.textColor = UIColor.whiteColor()
        
    }
    
    static func loadViewFromNib() -> ViewForRateHeader
    {
        let nib = UINib(nibName: "ViewForRateHeader", bundle: nil)
        let header = nib.instantiateWithOwner(self, options: nil)[0] as! ViewForRateHeader
        
        return header
    }

}
