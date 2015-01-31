//
//  MCTemplateHat.swift
//  MonsterAnim
//
//  Created by Andrew Adriance on 10/14/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MCTemplateHat : MCPartTemplate{
    var hat: SKTexture
    var hatColorable: Bool
    
    init(displayName: String, hatFile: String, hatColorable: Bool)
    {
        self.hat = SKTexture(imageNamed: hatFile + "_atlas")
        self.hatColorable = hatColorable
        
        super.init(displayName: displayName, fileName: hatFile, anchor: CGPoint(x: 0.5,y: 0.1), partType: PartType.hat)
        
        autoMirror = false
        autoRotate = false
    }
    
    override func partFromTemplate() -> MCPartHat{
        let node = SKSpriteNode(texture: hat)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.contactTestBitMask = 0x1
        node.physicsBody!.categoryBitMask = partCategory
        node.physicsBody!.collisionBitMask = 0x0
        node.physicsBody!.usesPreciseCollisionDetection = true
        node.setScale(0.5)
        node.anchorPoint = self.anchor
        
        
        var nodehat = MCPartHat(hat: node, template: self)
        nodehat.partTemplate.partType = PartType.hat
        return nodehat
    }
    
    override func colorable() -> Bool {
        return self.hatColorable
    }
}
