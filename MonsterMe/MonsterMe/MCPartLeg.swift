//
//  MCPartLeg.swift
//  MonsterAnim
//
//  Created by Andrew Adriance on 11/11/14.
//  Copyright (c) 2014 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartLeg: MCPartLimb {
    var visibleLeg: SKSpriteNode
    var baseAnchor: CGPoint
    
    override var partType: PartType {
        return .leg
    }
    
    /**
     * To let us rotate the leg around an arbitrary point, we create an invisible node
     *  that then has the actual displayed leg node as a child.
     *
     *  The heirarchy looks like:
     *     this        (invisible SKSpriteNode)
     *       |
     *       V
     *     legBase     (invisible SKSpriteNode)
     *       |
     *       V
     *     visibleLeg  (visible SKSpriteNode)
     * 
     *  For details, check out:
     *  http://stackoverflow.com/questions/19045067/is-it-possible-to-rotate-a-node-around-an-arbitrary-point-in-spritekit
     */
    init(textureName: String, color: UIColor, anchor: CGPoint, baseAnchor: CGPoint) {
        let newTexture = SKTexture(imageNamed: textureName)
        
        self.visibleLeg = SKSpriteNode(texture: newTexture, color: color, size: newTexture.size())
        self.visibleLeg.anchorPoint = anchor
        self.baseAnchor = baseAnchor
        
        // I am the invisible main node
        super.init(textureName: textureName, color: UIColor.clearColor(), anchor: anchor)
        
        //make the bottom rotator
        var legBase = SKSpriteNode(texture: newTexture, color: UIColor.clearColor(), size: newTexture.size())
        legBase.anchorPoint = baseAnchor
        
        //parent the base to the super
        legBase.name = "legBase"
        legBase.colorBlendFactor = 1
        
        //find the bases position relitive to the super
        legBase.position = CGPoint(
            x: (baseAnchor.x * legBase.frame.width) - (anchor.x * legBase.frame.width),
            y: (baseAnchor.y * legBase.frame.height) - (anchor.y * legBase.frame.height))
        self.addChild(legBase)
        
        //find the visible nodes position relitive to the super and base
        visibleLeg.position = CGPoint(
            x: (visibleLeg.anchorPoint.x * legBase.frame.width) - (legBase.anchorPoint.x * legBase.frame.width),
            y: (visibleLeg.anchorPoint.y * legBase.frame.height) - (legBase.anchorPoint.y * legBase.frame.height))
        legBase.addChild(visibleLeg)
    }
    
    override func setColorNotColliding(){
        visibleLeg.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        visibleLeg.colorBlendFactor = 0.75
    }
    
    override func setColorColliding() {
        visibleLeg.color = savedColor
        visibleLeg.colorBlendFactor = 1.0
    }
    
//    override func animate(anim: MCAnimationComp, parent:SKNode) {
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
    
    override func setTentativeColor(newColor: UIColor) {
        tentativeColor = newColor
        visibleLeg.color = newColor
        visibleLeg.colorBlendFactor = 1.0
    }
    
    override func restoreColor() {
        visibleLeg.color = savedColor
        visibleLeg.colorBlendFactor = 1.0
        tentativeColor = nil
    }
    
    // TODO: Make this call super before it does anything too crazy
    override func convertToDictionary() -> NSDictionary {
        var dict: [NSString: AnyObject] = [:]
        dict["partType"] = self.partType.rawValue as NSString
        
        dict["posX"]     = self.position.x.description
        dict["posY"]     = self.position.y.description
        dict["rotation"] = self.savedAngle.description
        dict["scale"]    = self.savedScale.description
        dict["hidden"]   = self.hidden.description
        var components = CGColorGetComponents(visibleLeg.color.CGColor)
        var alpha = CGColorGetAlpha(visibleLeg.color.CGColor)
        
        dict["colorR"] = components[0].description
        dict["colorG"] = components[1].description
        dict["colorB"] = components[2].description
        dict["colorA"] = alpha.description
        dict["isMirrored"] = (isMirroredPart).description

        if let mir = mirroredPart {
            dict["mirror"] = mir.partUUID
        }
        return dict
    }
}
