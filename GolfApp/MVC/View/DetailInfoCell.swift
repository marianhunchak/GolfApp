//
//  DetailCouseFooter.swift
//  GolfApp
//
//  Created by Admin on 11.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

let BASE_CELL_HEIGHT: Float = 50

class DetailInfoCell: UITableViewCell {
    
    // MARK: - Connections elements 

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var backgroundCourseFooter: UIView!

    @IBOutlet weak var detailLabelHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCourseFooter.layer.cornerRadius = 5
        backgroundCourseFooter.backgroundColor = Global.descrTextBoxColor
        backgroundColor = Global.viewsBackgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
         backgroundCourseFooter.backgroundColor = Global.descrTextBoxColor
         backgroundCourseFooter.layer.borderWidth = 0.0
         nameLabel.textColor = Global.navigationBarColor
        
    }
    
    //MARK: Private methods
    
    func setCellSelected() {
        backgroundCourseFooter.backgroundColor = Global.navigationBarColor
        nameLabel.textColor = UIColor.whiteColor()
        backgroundCourseFooter.layer.borderWidth = 2
        backgroundCourseFooter.layer.borderColor = Global.menuBarStokeColor.CGColor
        backgroundCourseFooter.layer.masksToBounds = true

    }

}
