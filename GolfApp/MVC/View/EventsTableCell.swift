//
//  EventsTableCell.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/24/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

class EventsTableCell: UITableViewCell {
    
    //MARK: Outlets
    @IBOutlet weak var viewForBackground: UIView!
    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var eventNameLabel: UILabel!
    @IBOutlet weak var eventDescrLabel: UILabel!
    @IBOutlet weak var cellImageView: UIImageView!
    @IBOutlet weak var containerViewForImg: UIView!
    
    //MARK: Constraints
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentView.backgroundColor = Global.viewsBackgroundColor
        viewForBackground.backgroundColor = Global.descrTextBoxColor
        dataLabel.backgroundColor = Global.navigationBarColor
        dataLabel.layer.borderColor = UIColor.whiteColor().CGColor
        containerViewForImg.backgroundColor = Global.descrTextBoxColor
        viewForBackground.layer.borderWidth = 1
        viewForBackground.layer.borderColor = Global.menuBarStokeColor.CGColor
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    //MARK: Private methods
    
    func hideImage() {
        
        cellImageView.hidden = true
        imageWidth.constant = 0.0
    }
    
    func showImage() {
        cellImageView.hidden = false
        imageWidth.constant = 45.0
    }
    
}
