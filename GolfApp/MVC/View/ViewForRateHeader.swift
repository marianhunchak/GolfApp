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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        textLabeForRateHeader.backgroundColor = UIColor.blackColor()
        textLabeForRateHeader.textColor = UIColor.whiteColor()
        
    }
    

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    static func loadViewFromNib() -> ViewForRateHeader
    {
        let nib = UINib(nibName: "ViewForRateHeader", bundle: nil)
        let header = nib.instantiateWithOwner(self, options: nil)[0] as! ViewForRateHeader
        
        return header
    }

}
