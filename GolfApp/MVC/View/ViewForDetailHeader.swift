//
//  DetailCourseHeader.swift
//  GolfApp
//
//  Created by Admin on 11.05.16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import UIKit

protocol CourseHeaderDelegate {
    
    func tableCourseHeader(tableCourseHeader : ViewForDetailHeader ,button1Pressed button1 : AnyObject )
}

class ViewForDetailHeader: UIView {
    
    var delegate : CourseHeaderDelegate?
    
    // MARK: - Connections outlet elements DetailCourseHeader
    
    @IBOutlet weak var backgroundHeaderDetailCourse: UIView!
    @IBOutlet weak var button1: UIButton!
    @IBOutlet weak var button2: UIButton!
    @IBOutlet weak var button3: UIButton!
    


    override func awakeFromNib() {
        super.awakeFromNib()

        button1.layer.cornerRadius = 5
        button2.layer.cornerRadius = 5
        button3.layer.cornerRadius = 5
        backgroundHeaderDetailCourse.layer.cornerRadius = 5

    }
    
    // MARK: - Connections action elements DetailCourseHeader
    
    @IBAction func button1Action(sender: AnyObject) {
        self.delegate?.tableCourseHeader(self, button1Pressed: sender)
    }
    @IBAction func button2Action(sender: AnyObject) {
    }
    @IBAction func button3Action(sender: AnyObject) {
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
    }
    
    static func loadViewFromNib() -> ViewForDetailHeader
    {
        let nib = UINib(nibName: "ViewForDetailHeader", bundle: nil)
        let header = nib.instantiateWithOwner(self, options: nil)[0] as! ViewForDetailHeader
        
        return header
    }
 
}
