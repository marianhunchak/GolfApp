//
//  ProsTableCell.swift
//  GolfApp
//
//  Created by Admin on 17.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class ProsTableCell: UITableViewCell {
    
    
    @IBOutlet weak var prosImage: UIImageView!
    @IBOutlet weak var prosLabel: UILabel!
    


    override func awakeFromNib() {
        super.awakeFromNib()
        prosImage.layer.cornerRadius = 5.0
        prosImage.layer.masksToBounds = true
    }



}
