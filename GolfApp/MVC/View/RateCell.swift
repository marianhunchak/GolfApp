//
//  RateCell.swift
//  GolfApp
//
//  Created by Admin on 16.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class RateCell: UITableViewCell {
    
    @IBOutlet weak var toursLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var separeteView: UIView!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        toursLabel.intrinsicContentSize().width
        priceLabel.intrinsicContentSize().width
        
        priceLabel.textColor = Global.navigationBarColor
        separeteView.backgroundColor = Global.navigationBarColor
    }

}
