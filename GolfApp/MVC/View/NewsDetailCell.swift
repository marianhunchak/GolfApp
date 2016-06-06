//
//  NewsDetailCell.swift
//  GolfApp
//
//  Created by Admin on 20.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit


class NewsDetailCell: UITableViewCell {

    // MARK: - Connections elements
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var descriptionNews: UITextView!
    //@IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var backgroundCellView: UIView!
    @IBOutlet weak var dateLabel: UITextView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCellView.layer.cornerRadius = 5
        backgroundCellView.backgroundColor = Global.descrTextBoxColor
        backgroundColor = Global.viewsBackgroundColor
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        backgroundCellView.backgroundColor = Global.descrTextBoxColor
        backgroundCellView.layer.borderWidth = 0.0
        nameLabel.textColor = Global.navigationBarColor
        
    }
    
    //MARK: Private methods
    
    func setCellSelected() {
        backgroundCellView.backgroundColor = Global.navigationBarColor
        nameLabel.textColor = UIColor.whiteColor()
        backgroundCellView.layer.borderWidth = 2
        backgroundCellView.layer.borderColor = Global.menuBarStokeColor.CGColor
        backgroundCellView.layer.masksToBounds = true
        
    }
    
}