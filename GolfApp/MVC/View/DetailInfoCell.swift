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

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    //MARK: Private methods
//    
//    static func heightForDescrLabel(descrLabel:String, tableView: UITableView ) -> Float {
//        let lableSize = CGSize(width: tableView.frame.size.width - 30, height: 99999)
//        let size = (descrLabel as NSString).boundingRectWithSize(lableSize,
//                                                                 options: .UsesLineFragmentOrigin,
//                                                                 attributes: [NSFontAttributeName:],
//                                                                 context: nil).size
//        
//    }
//    
//    + (CGFloat)heightForInfoUser:(NSString *)infoUserLabel inTable:(UITableView *)tableView {
//    CGSize infoUserLabelSize = CGSizeMake(tableView.frame.size.width - 30.f, 99999);
//    CGSize size = [infoUserLabel boundingRectWithSize:infoUserLabelSize
//    options:NSStringDrawingUsesLineFragmentOrigin
//    attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.f]}
//    context:nil].size;
//    return BASE_CELL_HEIGHT + size.height;
//    }

}
