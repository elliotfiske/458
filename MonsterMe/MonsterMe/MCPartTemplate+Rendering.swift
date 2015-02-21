//
//  MCPartTemplate+Rendering.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/21/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

extension MCPartTemplate {
    func imageForPart() -> UIImage {
        // Eye is made of two images.  Thaaaanks, eyeball.
        if backFileName != nil {
            let backgroundImage = UIImage(contentsOfFile: backFileName!)!
            let pupilImage = UIImage(contentsOfFile: fileName)!
            
            UIGraphicsBeginImageContext(backgroundImage.size)
            backgroundImage.drawInRect(CGRect(origin: CGPointZero, size: backgroundImage.size))
            
            var pupilRect = CGRect(origin: CGPointZero, size: pupilImage.size)
            pupilRect.origin.x = backgroundImage.size.width/2.0 - pupilImage.size.width/2
            pupilRect.origin.y = backgroundImage.size.height/2.0 - pupilImage.size.height/2
            pupilImage.drawInRect(pupilRect)
            
            let result = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return result
        }
        else {
            var img = UIImage(contentsOfFile: fileName)!
            if colorable {
                img = img.imageWithRenderingMode(.AlwaysTemplate)
            }
            return img
        }
    }
}