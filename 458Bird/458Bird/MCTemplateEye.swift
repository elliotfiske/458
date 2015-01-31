//
//  MCTemplateEye.swift
//  MonsterAnim
//
//  Created by Kyle Piddington on 8/5/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit
import UIKit

class MCTemplateEye: MCPartTemplate {
    var backgroundEye: SKTexture
    var pupil: SKTexture
    var image: UIImageView

    init(displayName: String, background: String, pupil: String, anchor: CGPoint) {
        self.backgroundEye = SKTexture(imageNamed: background + "_atlas")
        self.pupil = SKTexture(imageNamed: pupil + "_atlas")
        let backImage = UIImageView(image: UIImage(named: background)) //set back image
        let pupilImage = UIImageView(image: UIImage(named: pupil)) //set pupil image
        pupilImage.center = backImage.center //align images
        backImage.addSubview(pupilImage) //combine images
        UIGraphicsBeginImageContextWithOptions(backImage.bounds.size, backImage.opaque, 0.0)
        //turn in black magic ^
        backImage.layer.renderInContext(UIGraphicsGetCurrentContext()) //turn image into a flatten image
        let tempImage = UIGraphicsGetImageFromCurrentImageContext()
        //take the flatten image into a new tempImage^
        image = UIImageView(image: tempImage) //make the tempimage the view
        UIGraphicsEndImageContext()
        //Change later for dynamic eye update \/
        super.init(displayName: displayName, fileName: "spr_eyeComplete", anchor: anchor, partType: PartType.eye)
        
        autoRotate = false
    }
    
    convenience init(templateTable: Dictionary<String, MCPartTemplate>, eyePrefix: String) {
        let back = templateTable[eyePrefix + "back"]
        let pupil = templateTable[eyePrefix + "front"]
        
        self.init(displayName: eyePrefix,
            background: back!.fileName,
            pupil: pupil!.fileName,
            anchor: back!.anchor)
        
    }
    override func partFromTemplate() -> MCPartEye {
        let node = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: backgroundEye.size().width, height: backgroundEye.size().height))
        let backNode = SKSpriteNode(texture: backgroundEye)
        backNode.anchorPoint = anchor
        backNode.name = "back"
        node.addChild(backNode)
        backNode.zPosition = -1
        let pupilNode = SKSpriteNode(texture: pupil)
        pupilNode.anchorPoint = anchor
        pupilNode.name = "pupil"
        node.addChild(pupilNode)
        pupilNode.zPosition = 1
        let emoNode = SKSpriteNode(texture: backgroundEye)
        backNode.anchorPoint = anchor
        emoNode.name = "emoEye"
        node.physicsBody = SKPhysicsBody(circleOfRadius: 20.0)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.contactTestBitMask = 0x1
        node.physicsBody!.categoryBitMask = partCategory
        node.physicsBody!.collisionBitMask = 0x0
        node.physicsBody!.usesPreciseCollisionDetection = true
        node.setScale(0.5)
        
        var builtEyeNode =  MCPartEye(base: node, background: backNode, pupil: pupilNode, template: self)
        builtEyeNode.partTemplate.partType = PartType.eye
        builtEyeNode.node.addChild(emoNode)
        return builtEyeNode
    }
    
    override func imageName() -> String {
        return "spr_eyeComplete"
    }
    
    func getIcon() -> UIImageView {
        return image
    }
}