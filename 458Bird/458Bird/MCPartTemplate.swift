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
    
    var texture:  SKTexture?
    var backTexture: SKTexture?
    
    /** Filename of the texture image */
    var fileName: String
    /** Filename of the background (currently only for eye cornea images) */
    var backFileName: String?
    /** What name shows up under each part on the toolbar */
    var displayName: String
    
    var anchor:   CGPoint
    var baseAnchor: CGPoint?
    
    var partType: PartType!
    let baseCategory: UInt32 = 1 << 1
    let partCategory: UInt32 = 1 << 0
    var autoMirror: Bool = true
    var autoRotate: Bool = true
    
    var index = -1
    var color: UIColor {
        get {
            return UIColor.purpleColor()
        }
    }
    
    init(displayName:String, fileName:String, anchor:CGPoint, partType:PartType){
        self.displayName = displayName
        self.fileName = fileName
        self.anchor = anchor
        self.partType = partType
        if(partType == PartType.mouth){
            autoMirror = false
        }
    }
    
    class func partFromJSON(jsonData: Dictionary<String, AnyObject>, type: PartType, index: Int) -> MCPartTemplate {
        let fileName = jsonData["imageName"] as String
        let displayName = jsonData["displayName"] as String
        var anchor = CGPoint(x: 0.5, y: 0.5) // Anchor defaults to center
        if contains(jsonData.keys, "anchorX") {
            anchor = CGPoint(x: jsonData["anchorX"] as CGFloat, y: jsonData["anchorY"] as CGFloat)
        }
        
        var result: MCPartTemplate!
    
        // Initiate the correct MonsterPart template.
        switch(type) {
        case .mouth:
            result = MCTemplateMouth(displayName: displayName, fileName: fileName)
            result.autoMirror = false
        case .leg:
            let baseAnchor = CGPoint(x: jsonData["baseAnchorX"] as CGFloat,
                                     y: jsonData["baseAnchorY"] as CGFloat)
            result = MCTemplateLeg(displayName: displayName,
                                fileName: fileName,
                                anchor: anchor,
                                partType: PartType.leg,
                                baseAnchor: baseAnchor)
        case .eye:
            let backFileName = jsonData["backImageName"] as String
            result = MCTemplateEye(displayName: displayName,
                                background: backFileName,
                                pupil: fileName,
                                anchor: anchor)
        case .decal:
            let type = jsonData["decalType"] as String
            let colorable = jsonData["colorable"] as Bool
            
            if (type == "hat") {
                result = MCTemplateHat(displayName: displayName, hatFile: fileName, hatColorable: colorable)
            }
            else if (type == "stuff") {
                result = MCTemplateStuff(displayName: displayName, stuffFile: fileName, stuffColorable: colorable)
            }
            else {
                println("uh oh.  unknown decal type: \(type)")
            }
            result.autoMirror = false
        case .body:
            result = MCTemplateHat(displayName: displayName, hatFile: fileName, hatColorable: false)
            
            
        case .color:
            let hexString = jsonData["hex"] as String
            let scanner = NSScanner(string: hexString)
            var hexColor: UInt32 = 0
            scanner.scanHexInt(&hexColor)
            
            result = MCTemplateColor(displayName: displayName, hex: Int(hexColor))
        default:
            result = MCPartTemplate(displayName: displayName,
                                     fileName: fileName,
                                     anchor: anchor,
                                     partType: type)
        }
        result.index = index
        return result
    }
    
    
    func partFromTemplate() -> MCPart {
        println("Cloning for: " + displayName)
        if (texture == nil) {
            
            self.texture = SKTexture(imageNamed: fileName + "_atlas")
            if (backFileName != nil) {
                self.backTexture = SKTexture(imageNamed: backFileName!)
            }
        }
        
        let node = SKSpriteNode(texture: self.texture!)
        if(self.partType == PartType.body)
        {
            node.physicsBody!.categoryBitMask = baseCategory
            node.physicsBody!.collisionBitMask = 0x0
            //node.physicsBody!.usesPreciseCollisionDetection = true
            print("Body part loaded")
        }
        else {
            node.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
            node.physicsBody!.affectedByGravity = false
            node.physicsBody!.categoryBitMask = partCategory
            node.physicsBody!.collisionBitMask = 0x0
            node.physicsBody!.usesPreciseCollisionDetection = true
        }
        node.anchorPoint = self.anchor
        
        let part = MCPart(aNode: node, template: self)
        return part   
    }
    
    func description()->String{
        return displayName + "--" + fileName
    }
    
    func imageName()->String{
        return fileName
    }
    
    /**
     * Return the image view that will be used in the part cell in the parts collection view
     */
    func dragDropImage() -> UIImageView {
        var image: UIImageView
        
        if (partType == PartType.body) || (partType == PartType.leg) || (partType == PartType.arm) {
            var imagetemp = UIImage(named: fileName)!
            imagetemp = imagetemp.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            image = UIImageView(image: imagetemp)
//            image.tintColor = BuilderSKScene.currScene!.monColor()
        }
        else if (partType == PartType.decal) {
            var imagetemp = UIImage(named: fileName)!
            imagetemp = imagetemp.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            image = UIImageView(image: imagetemp)
            if colorable() {
//                image.tintColor = BuilderSKScene.currScene!.monColor()
            }
        }
        else if (partType == PartType.eye) {
            image = (self as MCTemplateEye).getIcon()
        }
        else if (partType == PartType.color) {
            var imgFile = UIImage(named: fileName)!
            imgFile = imgFile.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            image = UIImageView(image: imgFile)
//            image.tintColor = (self as MCTemplateColor).color
        }
        else {
            image = UIImageView(image: UIImage(named:fileName))
        }
        
        return image
    }
    
    /**
     * Return the (untinted) image for a particular part template
     */
    func imageForPart() -> UIImage {
        if (partType == PartType.eye) {
            let eye = self as MCTemplateEye
            return eye.getIcon().image!
        }
        else {
            var img = UIImage(named: fileName)!
            if colorable() {
                img = img.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            }
            return img
        }
    }
    
    func colorable() -> Bool {
        switch(partType!) {
        case .arm, .body, .leg, .color:
            return true
        default:
            return false
        }
    }
}