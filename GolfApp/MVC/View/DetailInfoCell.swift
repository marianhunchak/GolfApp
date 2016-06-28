//
//  DetailCouseFooter.swift
//  GolfApp
//
//  Created by Admin on 11.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class DetailInfoCell: UITableViewCell {
    
    // MARK: - Connections elements 

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundCourseFooter: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCourseFooter.layer.cornerRadius = 5
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
