//
//  MCPartEye.swift
//  MonsterAnim
//
//  Created by Kyle Piddington on 7/27/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartEye : MCPart{
    private var backgroundNode: SKSpriteNode
    var pupilNode: SKSpriteNode
    private var targetPupilPosition: CGPoint = CGPoint(x: 0, y: 0)
    var animateAttachPoint=CGPoint()
    init(base: SKSpriteNode, background: SKSpriteNode,  pupil: SKSpriteNode, template: MCPartTemplate){
        backgroundNode = background
        pupilNode = pupil
        pupilNode.name = "pupil"
        super.init(aNode: base, template: template)
        self.node.color = UIColor.clearColor()
        self.node.colorBlendFactor = 0
        minScale = CGFloat(0.25)
        maxScale = CGFloat(1)
        scale = 0.5
    }
    
    override func setColorNotColliding() {
        backgroundNode.color = UIColor.clearColor()
        backgroundNode.colorBlendFactor = 0.75
    }
    
    override func setColorColliding() {
        backgroundNode.color = UIColor.whiteColor()
        backgroundNode.colorBlendFactor = 0.0
    }
    
    override func parentToNode(pNode: SKNode) {
        super.parentToNode(pNode)
        self.blink(0.1)
        self.blink(0.1)
    }
    
    func lookTowardsPoint(pt: CGPoint, base: MCPartBody) {
        var dy: CGFloat = pt.y - (base.node.position.y)
        var dx: CGFloat = pt.x - (base.node.position.x)
        
        var dist = sqrt(dx*dx + dy*dy)
        if (dist > 1) {
            if fabs(dy/dist) > 0.95 {
                let newPt = pointInNode(base.node.parent!)
                dy = pt.y - newPt.y
                dx = pt.x - newPt.x
                dist = fmax(sqrt(dx*dx + dy*dy),0.01)
            }
            
            if (!selected) {
                dx = -dx
            }
            
            dx /= dist
            dy /= dist
            
            targetPupilPosition = CGPoint(x: dx, y: dy)
        }
        else {
            targetPupilPosition = CGPoint()
        }
    }
    
    func setEyeEmotion(emotion:EyeEmotion, time:Double) {
        //emotionNode = SKSpriteNode(texture: emotion.getTexture())
        //node.addChild(emotionNode)
        let hideAction = SKAction.hide()
        backgroundNode.runAction(hideAction)
        pupilNode.runAction(hideAction)
    }
    
    func blink(time: Double) {
        let hideAction = SKAction.sequence([SKAction.hide(),SKAction.waitForDuration(time),SKAction.unhide()])
        backgroundNode.runAction(hideAction)
        pupilNode.runAction(hideAction)
    }
    
    override func update() {
        super.update()
        var ang = angle
        if (!selected) {
            ang = -ang
        }
        let dx = ( cos(ang)*targetPupilPosition.x + sin(ang)*targetPupilPosition.y)
        let dy = (-sin(ang)*targetPupilPosition.x + cos(ang)*targetPupilPosition.y)
        let pupPos = CGPoint(x: dx,y: dy)
        
        pupilNode.runAction(SKAction.moveTo(CGPoint(x: pupPos.x * fabs(backgroundNode.frame.width*0.1), y: pupPos.y * fabs(backgroundNode.frame.height*0.1)),duration: 0.1))
    }
    
    func center() {
        self.targetPupilPosition = CGPoint()
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
        
        pupilNode.runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
        backgroundNode.runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
        animateAttachPoint = CGPoint(x:lockPoint!.x,y:lockPoint!.y)
        lockPoint = newPoint
        
    }
    override func animateAttachToMonster(base:MCPartBody){
        var newScale = CGPoint(x:scale,y:scale)
        if !selected{
            newScale.x = -newScale.x
        }
        node.runAction(SKAction.group([SKAction.scaleXTo(newScale.x, duration: 0.2),SKAction.scaleYTo(newScale.y,duration:0.2)]))
        pupilNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
        backgroundNode.runAction(SKAction.fadeAlphaTo(1, duration: 0.2))
        lockPoint = animateAttachPoint
        if let physWorld = node.scene?.physicsWorld
        {
            
            //selectForCollsion()
//            physWorld.enumerateBodiesAlongRayStart(base.node.parent!.convertPoint(animateAttachPoint, fromNode:node.parent!), end: base.node.position, usingBlock: castRayToCenter)
            //deselectForCollsion()
        }
    }
    override func setTentativeColor(newColor: UIColor) {
        tentativeColor = newColor
        backgroundNode.color = newColor;
    }
}



class EyeEmotion{
    var emotionTexture: SKTexture
    init(filename: String) {
        emotionTexture = SKTexture(imageNamed: filename)
    }
    
    func getTexture()->SKTexture {
        return emotionTexture
    }
}