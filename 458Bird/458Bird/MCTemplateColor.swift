//
//  MCPartColorTemplate.swift
//  MonsterAnim
//
//  Created by Elliot Fiske on 12/10/14.
//  Copyright (c) 2014 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class MCTemplateColor: MCPartTemplate {
    var hexColor: Int // This color's hue in hex
    var uiColor: UIColor // This color's hue as a UIColor
    override var color: UIColor {
        get {
            return uiColor
        }
    }
    
    init(displayName: String, hex: Int) {
        hexColor = hex
        uiColor = UIColor.redColor()
        super.init(displayName: displayName, fileName: "circleImage", anchor:CGPoint(x: 0.5, y: 0.5), partType: PartType.color)
        autoMirror = false
        autoRotate = false
        fileName = "circleImage"
    }
    
    override func partFromTemplate() -> MCPart {
        if (texture == nil) {
            self.texture = SKTexture(imageNamed: fileName)
            if (backFileName != nil) {
                self.backTexture = SKTexture(imageNamed: backFileName!)
            }
        }
        
        let node = SKSpriteNode(texture: self.texture!)
        node.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        node.physicsBody!.affectedByGravity = false
        node.physicsBody!.contactTestBitMask = 0x1
//        node.physicsBody!.categoryBitMask = colorCategory
        node.physicsBody!.collisionBitMask = 0x0
        node.physicsBody!.usesPreciseCollisionDetection = true
        node.anchorPoint = self.anchor
        
        let part =  MCPartColor(aNode: node, template: self)
        return part
    }
}