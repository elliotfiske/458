////
////  MCPartMouth.swift
////  MonsterAnim
////
////  Created by Andrew Adriance on 10/11/14.
////  Copyright (c) 2014 Kyle Piddington. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//
//class MCPartMouth: MCPart {
//    
//    override init(textureName: String, color: UIColor) {
//        super.init(textureName: textureName, color: color)
//        
//        self.partType = .mouth
//        self.color = UIColor.clearColor()
//        self.colorBlendFactor = 0
//        self.setScale(0.5)
//    }
//
//    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    override func parentToNode(pNode: SKNode) {
//        super.parentToNode(pNode)
//        xScale = abs(xScale) // Don't let the user flip the scales
//    }
//    
//    override func animateDetatchFromMonster() {
//        var newPoint = CGPoint(x: position.x, y: position.y + 20)
//
//        var newScale = CGPoint(x:scale+0.1, y:scale+0.1)
//        
//        runAction(SKAction.group([SKAction.scaleXTo(newScale.x, duration: 0.2), SKAction.scaleYTo(newScale.y,duration:0.2)]))
//        runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
//        animateAttachPoint = CGPoint(x:lockPoint!.x,y:lockPoint!.y)
//        lockPoint = newPoint
//    }
//    
//    override func animateAttachToMonster(base:MCPartBody){
//        var newScale = CGPoint(x:scale,y:scale)
//        if isMirroredPart{
//            newScale.x = -newScale.x
//        }
//        node.runAction(SKAction.group([SKAction.scaleXTo(newScale.x, duration: 0.2),SKAction.scaleYTo(newScale.y,duration:0.2)]))
//        node.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
//        lockPoint = animateAttachPoint
//        if let physWorld = node.scene?.physicsWorld
//        {
//            
//            //selectForCollsion()
////            physWorld.enumerateBodiesAlongRayStart(base.node.parent!.convertPoint(animateAttachPoint, fromNode:node.parent!), end: base.node.position, usingBlock: castRayToCenter)
//            //deselectForCollsion()
//        }
//    }
//
//    
//    
//}
