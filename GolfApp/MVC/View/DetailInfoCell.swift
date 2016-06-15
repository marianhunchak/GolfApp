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
    
    var displayNewNewsImage: Bool! {
        didSet {
            newNewsImageView.hidden = false
        }
    }
    
    // MARK: - Connections elements 

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var newNewsImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UITextView!
    @IBOutlet weak var backgroundCourseFooter: UIView!

    @IBOutlet weak var detailLabelHeight: NSLayoutConstraint!
    
    var tableView : UITableView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        backgroundCourseFooter.layer.cornerRadius = 5
        backgroundCourseFooter.backgroundColor = Global.descrTextBoxColor
        backgroundColor = Global.viewsBackgroundColor

        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        descriptionLabel.addGestureRecognizer(tapGesture)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
         backgroundCourseFooter.backgroundColor = Global.descrTextBoxColor
         backgroundCourseFooter.layer.borderWidth = 0.0
         nameLabel.textColor = Global.navigationBarColor
        
        if displayNewNewsImage != nil {
            newNewsImageView.hidden = true
        }
        
    }
    
    //MARK: Private methods
    
    func setCellSelected() {
        backgroundCourseFooter.backgroundColor = Global.navigationBarColor
        nameLabel.textColor = UIColor.whiteColor()
        backgroundCourseFooter.layer.borderWidth = 2
        backgroundCourseFooter.layer.borderColor = Global.menuBarStokeColor.CGColor
        backgroundCourseFooter.layer.masksToBounds = true

    }
    
    func handleTapGesture() {
        
        let indexPath = NSIndexPath(forRow: self.tag, inSection: 0)
        if tableView != nil {
            self.tableView.delegate?.tableView!(tableView, didSelectRowAtIndexPath: indexPath)
        }
    }

}
