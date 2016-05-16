//
//  UIImage+Size.swift
//  GolfApp
//
//  Created by Marian Hunchak on 5/15/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation
import UIKit
/**
 Extension UIView
 by DaRk-_-D0G
 */
extension UIView {
    /**
     Set x Position
     
     :param: x CGFloat
     by DaRk-_-D0G
     */
    func setX(x:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.x = x
        self.frame = frame
    }
    /**
     Set y Position
     
     :param: y CGFloat
     by DaRk-_-D0G
     */
    func setY(y:CGFloat) {
        var frame:CGRect = self.frame
        frame.origin.y = y
        self.frame = frame
    }
    /**
     Set Width
     
     :param: width CGFloat
     by DaRk-_-D0G
     */
    func setWidth(width:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.width = width
        self.frame = frame
    }
    /**
     Set Height
     
     :param: height CGFloat
     by DaRk-_-D0G
     */
    func setHeight(height:CGFloat) {
        var frame:CGRect = self.frame
        frame.size.height = height
        self.frame = frame
    }
    
    func setSize(size:CGSize) {
        var frame:CGRect = self.frame
        frame.size.height = size.height
        frame.size.width = size.width
        self.frame = frame
    }
}