//
//  MCPartEye.swift
//  MonsterAnim
//
//  Created by Kyle Piddington on 7/27/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartEye: MCPart {
    override var partType: PartType {
        return .eye
    }
    
    var pupilNode: SKSpriteNode
    
    private var targetPupilPosition = CGPointZero
    
    /**
     * The MCPartEye consists of the white background to the eye (the base SKNode)
     *  and the pupil (a child of the background).
     *  
     *  Note that some eyes don't have a white background (i.e. they're just pupils),
     *  so we use the textureName "blankEye" in that case.
     */
    init(textureName: String, color: UIColor, anchor: CGPoint, pupilTextureName: String) {
        pupilNode = SKSpriteNode(imageNamed: pupilTextureName)
        super.init(textureName: textureName, color: color, anchor: anchor)
        
        self.addChild(pupilNode)
        pupilNode.position = targetPupilPosition
        minScale = 0.1
    }
    
    override func setColorNotColliding() {
        super.setColorNotColliding()
        pupilNode.color = UIColor.clearColor()
        pupilNode.colorBlendFactor = 0.75
    }
    
    override func setColorColliding() {
        super.setColorColliding()
        pupilNode.color = UIColor.whiteColor()
        pupilNode.colorBlendFactor = 0.0
    }
    
    func lookTowardsPoint(pt: CGPoint, base: MCPartBody) {
        if self.scene == nil {
            return
        }
        
        let scenePoint = convertPoint(self.position, toNode: self.scene!)
        
        let diff = pt - scenePoint
        
        var dy: CGFloat = diff.y
        var dx: CGFloat = diff.x
        
        var dist = sqrt(dx*dx + dy*dy)
        if (dist > 1) {
            if fabs(dy/dist) > 0.95 {
                let newPt = pointInNode(base.parent!)
                dy = pt.y - newPt.y
                dx = pt.x - newPt.x
                dist = fmax(sqrt(dx*dx + dy*dy),0.01)
            }
            
            if (isMirroredPart) {
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
    
    func blink(time: Double) {
        // todo
    }
    
    override func update() {
        super.update()
        var ang = angle
        if (isMirroredPart) {
            ang = -ang
        }
        let dx = ( cos(ang)*targetPupilPosition.x + sin(ang)*targetPupilPosition.y)
        let dy = (-sin(ang)*targetPupilPosition.x + cos(ang)*targetPupilPosition.y)
        let pupPos = CGPoint(x: dx,y: dy)
        
        pupilNode.runAction(SKAction.moveTo(CGPoint(x: pupPos.x * fabs(frame.width*0.1), y: pupPos.y * fabs(frame.height*0.1)),duration: 0.1))
    }
    
    func center() {
        self.targetPupilPosition = CGPoint()
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}