//
//  File.swift
//  MonsterAnim
//
//  Created by Kyle Piddington on 8/5/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartTemplate {
    
    var texture:  SKTexture
    var backTexture: SKTexture?
    
    /** Filename of the texture image */
    var fileName: String
    /** Filename of the background (currently only for eye cornea images) */
    var backFileName: String?
    /** What name shows up under each part on the toolbar */
    var displayName: String
    
    var anchor:   CGPoint
    var baseAnchor: CGPoint?
    
    var partType: PartType
    var autoMirror = true
    var autoRotate = true
    
    /** The color for a MCPartColor */
    var color: UIColor?
    var colorable = true
    
    var index = -1
    
    init(displayName: String, fileName: String, anchor: CGPoint, partType: PartType) {
        self.displayName = displayName
        self.fileName = fileName
        self.anchor = anchor
        self.partType = partType
    }
    
    /**
     * Instantiate a part template from JSON data!
     */
    class func templateFromJSON(jsonData: Dictionary<String, AnyObject>, type: PartType, index: Int) -> MCPartTemplate {
        let fileName = jsonData["imageName"] as String
        let displayName = jsonData["displayName"] as String
        
        var anchor = CGPoint(x: 0.5, y: 0.5) // Anchor defaults to center
        if contains(jsonData.keys, "anchorX") {
            anchor = CGPoint(x: jsonData["anchorX"] as CGFloat, y: jsonData["anchorY"] as CGFloat)
        }
        
        var result = MCPartTemplate(displayName: displayName, fileName: fileName, anchor: anchor, partType: type)
    
        // Put in custom attributes for different part types
        switch(type) {
        case .mouth:
            result.autoMirror = false
        case .leg:
            let baseAnchor = CGPoint(x: jsonData["baseAnchorX"] as CGFloat,
                                     y: jsonData["baseAnchorY"] as CGFloat)
            result.baseAnchor = baseAnchor
        case .eye:
            let backFileName = jsonData["backImageName"] as String
            result.backFileName = backFileName
        case .decal:
            let colorable = jsonData["colorable"] as Bool
            result.colorable = colorable
            result.autoMirror = false
        default:
            break
        }
        
        result.index = index
        return result
    }
    
    /**
     * Create the specified part from the 
    func partFromTemplate() -> MCPart {
        if (texture == nil) {
            
            self.texture = SKTexture(imageNamed: fileName + "_atlas")
            if (backFileName != nil) {
                self.backTexture = SKTexture(imageNamed: backFileName!)
            }
        }
        
        let node = SKSpriteNode(texture: self.texture!)
        node.anchorPoint = self.anchor
        
        return part   
    }
    
    func description() -> String {
        return displayName + "--" + fileName
    }
}