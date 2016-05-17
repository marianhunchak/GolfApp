//
//  ImageCollectionCell.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/9/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class ImageCollectionCell: UICollectionViewCell {
    
    // MARK: - Connections outlet elements 

    @IBOutlet weak var cellImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        cellImageView.layer.cornerRadius = 5
        cellImageView.layer.masksToBounds = true
    }

}
