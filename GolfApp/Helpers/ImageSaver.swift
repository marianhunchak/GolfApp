//
//  ImageSaver.swift
//  GolfApp
//
//  Created by Admin on 6/6/16.
//  Copyright © 2016 Marian Hunchak. All rights reserved.
//

import Foundation

class ImageSaver  {
    
    class func saveImage(image: UIImage, name: String) {
        
        let jpgImageData = UIImageJPEGRepresentation(image, 1.0)
        let path = self.fileInDocumentsDirectory(name)
        jpgImageData!.writeToFile(path, atomically: true)
    }
    
    class func getDocumentsURL() -> NSURL {
        let documentsURL = NSFileManager.defaultManager().URLsForDirectory(.DocumentDirectory, inDomains: .UserDomainMask)[0]
        return documentsURL
    }
    
    class func fileInDocumentsDirectory(filename: String) -> String {
        
        let fileURL = getDocumentsURL().URLByAppendingPathComponent(filename)
        return fileURL.path!
        
    }
}