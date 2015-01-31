//
//  MCPartMouth.swift
//  MonsterAnim
//
//  Created by Andrew Adriance on 10/11/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartMouth : MCPart{
    var animateAttachPoint:CGPoint = CGPoint()
    override init(aNode: SKSpriteNode, template: MCPartTemplate) {
        super.init(aNode: aNode, template: template)
        
        self.partTemplate.partType = PartType.mouth
        self.node.color = UIColor.clearColor()
        self.node.colorBlendFactor = 0
        scale = 0.5;
    }
    
    
    override func parentToNode(pNode: SKNode) {
        super.parentToNode(pNode)
        if node.xScale < 0 {
            node.xScale = -node.xScale
        }
        node.runAction(SKAction.rotateToAngle(0, duration: 0.1))

    }
    
    override func setColorNotColliding(){
        
        let backgroundNode: SKSpriteNode = node.childNodeWithName("visibleMouth") as SKSpriteNode
        backgroundNode.color = UIColor.clearColor()
        backgroundNode.colorBlendFactor = 0.75
        
    }
    override func setColorColliding(){
        let backgroundNode: SKSpriteNode = node.childNodeWithName("visibleMouth") as SKSpriteNode
        backgroundNode.color = UIColor.whiteColor()
        backgroundNode.colorBlendFactor = 0.0
    }
    override func animateDetatchFromMonster(){
        var newPoint:CGPoint
        var offset = CGFloat(20.0)
        newPoint = CGPoint(x: node.position.x, y: node.position.y + offset)
        var newScale = CGPoint(x:scale+0.1,y:scale+0.1)
        if !selected{
            newScale.x = -newScale.x
        }
        node.runAction(SKAction.group([SKAction.scaleXTo(newScale.x, duration: 0.2),SKAction.scaleYTo(newScale.y,duration:0.2)]))
        node.runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
        animateAttachPoint = CGPoint(x:lockPoint!.x,y:lockPoint!.y)
        lockPoint = newPoint
        
    }
    override func setTentativeColor(newColor: UIColor) {
        tentativeColor = newColor
        let backgroundNode: SKSpriteNode = node.childNodeWithName("visibleMouth") as SKSpriteNode
        backgroundNode.color = newColor;
    }
    override func animateAttachToMonster(base:MCPartBody){
        var newScale = CGPoint(x:scale,y:scale)
        if !selected{
            newScale.x = -newScale.x
        }
        node.runAction(SKAction.group([SKAction.scaleXTo(newScale.x, duration: 0.2),SKAction.scaleYTo(newScale.y,duration:0.2)]))
        node.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
        lockPoint = animateAttachPoint
        if let physWorld = node.scene?.physicsWorld
        {
            
            //selectForCollsion()
//            physWorld.enumerateBodiesAlongRayStart(base.node.parent!.convertPoint(animateAttachPoint, fromNode:node.parent!), end: base.node.position, usingBlock: castRayToCenter)
            //deselectForCollsion()
        }
    }

    
    
}
