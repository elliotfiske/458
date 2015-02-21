//
//  PartRotatorNode.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class PartRotatorNode: SKSpriteNode {
    weak var rotatingPart:       MCPart?
    weak var rotatingPartMirror: MCPart?
    
    /** Where was the rotator when the user JUST started dragging this part? */
    var baseDistance: CGFloat = 0
    
    override init() {
        let texture = SKTexture(imageNamed: "partRotator")
        super.init(texture: texture, color: UIColor.whiteColor(), size: texture.size())
        
        // Rotator node is in front of everyone.  Deal with it.
        self.zPosition = 100
        hideRotator()
    }

    /**
     * We just started rotating a new part.  Swoosh from the part's center to a
     *  bit above it.
     */
    func startRotatingPart(part: MCPart) {
        removeAllActions()
        
        rotatingPart = part
        rotatingPartMirror = part.mirroredPart  // might be nil
        
        position = part.position
        setScale(0)
        
        let growAction = SKAction.scaleTo(1, duration: 0.2)
        let swooshAction = SKAction.moveByX(0, y: 50, duration: 0.2) // TODO: I'd like to make this change based on the part's angle.  For now, just go straight up.
        swooshAction.timingMode = .EaseIn
        
        runAction(swooshAction)
        runAction(growAction)
        
        let initPoint = part.position + CGPoint(x: 0, y: 50)
        baseDistance = initPoint.distanceTo(point: rotatingPart!.position)
    }
    
    /**
     * User tapped elsewhere, and we're no longer rotating a part.
     */
    func hideRotator() {
        removeAllActions()
        
        rotatingPart = nil
        rotatingPartMirror = nil
        
        let shrinkAction = SKAction.scaleTo(0, duration: 0.2)
        runAction(shrinkAction)
    }
    
    /**
     * User dragged the rotator to a point.  Rotate the part we're
     *  assigned to!
     */
    func draggedToPoint(point: CGPoint) {
        if rotatingPart == nil {
            return
        }
        
        position = point
        
        let pointInBodyCoords = rotatingPart!.parent!.convertPoint(point, fromNode: self)
        rotatingPart!.rotateToFacePoint(pointInBodyCoords)
        rotatingPartMirror?.rotateToAngle(-rotatingPart!.savedAngle)
        
        var scaleChange = point.distanceTo(point: rotatingPart!.position) - baseDistance
        scaleChange /= 30 // Arbitrary scaling speed
        
        rotatingPart!.setScale(rotatingPart!.savedScale + scaleChange)
        rotatingPartMirror?.setScale(rotatingPartMirror!.savedScale + scaleChange)
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}