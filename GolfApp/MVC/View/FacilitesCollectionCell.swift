//
//  FacilitesCollectionCell.swift
//  GolfApp
//
//  Created by Admin on 14.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class FacilitesCollectionCell: UICollectionViewCell {
    
    @IBOutlet weak var facilitesCellImage: UIImageView!
    @IBOutlet weak var facilitesCellLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        facilitesCellImage.layer.cornerRadius = 10.0
        facilitesCellImage.layer.masksToBounds = true

    }
    
}
