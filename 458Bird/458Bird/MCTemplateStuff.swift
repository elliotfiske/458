//
//  MCTemplateStuff.swift
//  MonsterAnim
//
//  Created by Andrew Adriance on 10/17/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MCTemplateStuff : MCPartTemplate{
    var hat: SKTexture
    var stuffColorable: Bool
    
    init(displayName: String, stuffFile: String, stuffColorable: Bool) {
        self.hat = SKTexture(imageNamed: stuffFile + "_atlas")
        self.stuffColorable = stuffColorable
        super.init(displayName: displayName, fileName: stuffFile, anchor: CGPoint(x: 0.5,y: 0.5), partType: PartType.decal)
        autoMirror = false
        autoRotate = false
    }
    
    override func partFromTemplate() -> MCPartStuff {
        let node = SKSpriteNode(texture: hat)
        
        node.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.contactTestBitMask = 0x1
        node.physicsBody!.categoryBitMask = partCategory
        node.physicsBody!.collisionBitMask = 0x0
        node.physicsBody!.usesPreciseCollisionDetection = true
        node.setScale(0.5)
        node.anchorPoint = self.anchor
        
        var nodestuff = MCPartStuff(item: node, template: self)
        return nodestuff
    }
    
    override func colorable() -> Bool {
        return self.stuffColorable
    }
    
}
