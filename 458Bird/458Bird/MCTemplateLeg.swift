//
//  MCTemplateLeg.swift
//  MonsterAnim
//
//  Created by Andrew Adriance on 11/13/14.
//  Copyright (c) 2014 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit


class MCTemplateLeg: MCPartTemplate {
    var baseAnchorPoint: CGPoint
    
    init(displayName: String, fileName: String, anchor: CGPoint, partType: PartType, baseAnchor: CGPoint) {
        self.baseAnchorPoint = baseAnchor
        super.init(displayName: displayName, fileName: fileName, anchor: anchor, partType: partType)
    }
    
    override func partFromTemplate() -> MCPart {
        if (texture == nil) {
            self.texture = SKTexture(imageNamed: fileName + "_atlas")
        }
        
        let node = SKSpriteNode(texture: self.texture!)
        node.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.contactTestBitMask = 0x1
        node.physicsBody!.categoryBitMask = partCategory
        node.physicsBody!.collisionBitMask = 0x0
        node.physicsBody!.usesPreciseCollisionDetection = true
        node.anchorPoint = self.anchor
        
        let part = MCPartLeg(aNode: node, baseAnchor: baseAnchorPoint, template: self)
        return part
    }
}