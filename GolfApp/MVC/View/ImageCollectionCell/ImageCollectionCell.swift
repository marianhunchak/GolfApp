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
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

}
