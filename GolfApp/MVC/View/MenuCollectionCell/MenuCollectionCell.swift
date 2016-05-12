//
//  MenuCollectionCell.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class MenuCollectionCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var menuImageView: UIImageView!
    @IBOutlet weak var menuLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        cellView.layer.cornerRadius = 10.0
        cellView.layer.masksToBounds = true
        menuImageView.layer.cornerRadius = 7.0
        menuImageView.layer.masksToBounds = true
    }
    
}
