//
//  MCTemplateMouth.swift
//  MonsterAnim
//
//  Created by Andrew Adriance on 10/11/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MCTemplateMouth : MCPartTemplate{
    var mainMouth: SKTexture
    var currentMouth: SKTexture
    
    init(displayName: String, fileName: String) {
        self.mainMouth = SKTexture(imageNamed: fileName + "_atlas")
        self.currentMouth = self.mainMouth
        
        super.init(displayName: displayName, fileName: fileName, anchor: CGPoint(x: 0.5, y: 0.5), partType: PartType.mouth)
        autoRotate = false
    }
    
    override func partFromTemplate() -> MCPartMouth {
        let node = SKSpriteNode(color: UIColor.clearColor(), size: CGSize(width: mainMouth.size().width, height: mainMouth.size().height))
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        node.physicsBody!.affectedByGravity = false
        //node.physicsBody!.contactTestBitMask = 0x0
        node.physicsBody!.categoryBitMask = partCategory
        node.physicsBody!.collisionBitMask = 0x0
        node.physicsBody!.usesPreciseCollisionDetection = true
        node.setScale(0.5)
        
        let mouthNode = SKSpriteNode(texture: mainMouth)
        mouthNode.name = "visibleMouth"
        node.addChild(mouthNode)
        
        let mouthEmoNode = SKSpriteNode(texture: SKTexture(imageNamed: "mouthCute" + "_atlas"))
        mouthEmoNode.name = "emoMouth"
        node.addChild(mouthEmoNode)
        mouthEmoNode.runAction(SKAction.hide())
        
        var mouth = MCPartMouth(aNode: node, template: self)
        mouth.partTemplate.partType = PartType.mouth
        return mouth
    }
}
