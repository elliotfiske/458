//
//  MCPartLeg.swift
//  MonsterAnim
//
//  Created by Andrew Adriance on 11/11/14.
//  Copyright (c) 2014 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartLeg: MCPart {
    
    
    init(aNode:SKSpriteNode, baseAnchor: CGPoint, template: MCPartTemplate) {
        //make invisible main node
        var superLeg = SKSpriteNode(texture: aNode.texture, color: UIColor.clearColor(), size: aNode.size)
        superLeg.anchorPoint = aNode.anchorPoint
        
        //make the bottom rotator
        var legBase = SKSpriteNode(texture: aNode.texture, color: UIColor.clearColor(), size: aNode.size)
        legBase.anchorPoint = baseAnchor
        
        //parent the base to the super
        legBase.name = "legBase"
        superLeg.colorBlendFactor = 1
        legBase.colorBlendFactor = 1
        
        //find the bases position relitive to the super
        legBase.position = CGPoint(
            x: (baseAnchor.x * legBase.frame.width) - (aNode.anchorPoint.x * legBase.frame.width),
            y: (baseAnchor.y * legBase.frame.height) - (aNode.anchorPoint.y * legBase.frame.height))
        superLeg.addChild(legBase)
        
        
        
        //parent the original leg to the super node
        aNode.name = "legVisible"
        
        //find the visible nodes position relitive to the super and base
        aNode.position = CGPoint(
            x: (aNode.anchorPoint.x * legBase.frame.width) - (legBase.anchorPoint.x * legBase.frame.width),
            y: (aNode.anchorPoint.y * legBase.frame.height) - (legBase.anchorPoint.y * legBase.frame.height))
        legBase.addChild(aNode)
        
        superLeg.physicsBody = SKPhysicsBody(circleOfRadius: 10.0)
        superLeg.physicsBody!.affectedByGravity = false
        superLeg.physicsBody!.contactTestBitMask = 0x1
//        superLeg.physicsBody!.categoryBitMask = partCategory
        superLeg.physicsBody!.collisionBitMask = 0x0
        superLeg.physicsBody!.usesPreciseCollisionDetection = true
        
        
        super.init(aNode: superLeg, template: template)
        superLeg.color = UIColor.clearColor()
        superLeg.colorBlendFactor = 1
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func setColorNotColliding(){
        //get the visible leg node then change it's color
        var visibleNode = (node.childNodeWithName("legBase"))?.childNodeWithName("legVisible") as SKSpriteNode
        visibleNode.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        visibleNode.colorBlendFactor = 0.75
    }
    
    override func setColorColliding() {
        //get the visible leg node then change it's color
        var visibleNode = (node.childNodeWithName("legBase"))?.childNodeWithName("legVisible") as SKSpriteNode
        visibleNode.color = partColor
        visibleNode.colorBlendFactor = 1.0
    }
    
//    override func animate(anim: MonsterAnimation, parent:SKNode) {
//        if (anim.actsOn == PartType.leg) {
//            if (isMirroredPart) {
//                self.node.runAction(anim.animationM)
//            }
//            else {
//                self.node.runAction(anim.animation)
//            }
//        }
//        if (anim.actsOn == PartType.legBase) {
//            let baseNode = node.childNodeWithName("legBase")!
//            
//            if (isMirroredPart) {
//                baseNode.runAction(anim.animationM)
//            }
//            else {
//                baseNode.runAction(anim.animation)
//            }
//        }
//    }
    
    func animateVisibleLeg(action: SKAction) {
        let legNode = (node.childNodeWithName("legBase"))?.childNodeWithName("legVisible")!
        legNode!.runAction(action)
    }
    
    override func setTentativeColor(newColor: UIColor) {
        tentativeColor = newColor
        let legNode = (node.childNodeWithName("legBase"))?.childNodeWithName("legVisible")! as SKSpriteNode
        legNode.color = newColor
        legNode.colorBlendFactor = 1.0
    }
    
    override func restoreColor() {
        let legNode = (node.childNodeWithName("legBase"))?.childNodeWithName("legVisible")! as SKSpriteNode
        legNode.color = partColor
        legNode.colorBlendFactor = 1.0
        tentativeColor = nil
    }
    
    override func makeDescDict() -> NSDictionary
    {
        let legNode = (node.childNodeWithName("legBase"))?.childNodeWithName("legVisible")! as SKSpriteNode
        
        var dict: [NSString: AnyObject] = [:];
        if(self.partType == PartType.hat){
            dict["keyInDict"] = PartType.decal.rawValue as NSString;
        }
        else{
            dict["keyInDict"] = self.partType.rawValue as NSString;
        }
        dict["indexInDict"] = index.description;
        dict["posX"] = self.node.position.x.description
        dict["posY"] = self.node.position.y.description
        dict["rotation"] = self.angle.description
        dict["scale"] = self.scale.description
        dict["hidden"] = self.hidden.description;
        var components = CGColorGetComponents(legNode.color.CGColor)
        var alpha = CGColorGetAlpha(legNode.color.CGColor)
    
        dict["colorR"] = components[0].description
        dict["colorG"] = components[1].description
        dict["colorB"] = components[2].description
        dict["colorA"] = alpha.description
        dict["isMirrored"] = (isMirroredPart).description;
        println("Dictionary count value is : \(dict.count)");
        if let mir = mirroredPart{
            if(mir.isMirroredPart){
                dict["mirror"] = mir.makeDescDict();
            }
        }
    return dict;
    }
}
