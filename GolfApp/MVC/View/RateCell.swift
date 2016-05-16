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
    

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    static func loadViewFromNib() -> RateCell
    {
        let nib = UINib(nibName: "RateCell", bundle: nil)
        let cell = nib.instantiateWithOwner(self, options: nil)[0] as! RateCell
        
        return cell
    }

}
