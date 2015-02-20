//
//  MCAnimationComp.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/28/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import SpriteKit

class MCAnimation: NSObject {
    var comps = [MCAnimationComp]()
    
    /** How long does this entire animation take */
    var totalDuration: NSTimeInterval {
        var result: NSTimeInterval = 0
        for comp in comps {
            if comp.duration + comp.delay > result {
                result = comp.duration + comp.delay
            }
        }
        return result
    }
    
    var actionGroup: SKAction {
        var result = [SKAction]()
        for comp in comps {
            result += [comp.animation]
        }
        return SKAction.group(result)
    }
}

class MCAnimationComp: NSObject {
    var actsOn: PartType
    /** Does this animation affect the right, left, or both sides of the monster? */
    var actsOnSide: AnimSide
    var animation: SKAction
    var type: AnimType
    
    var duration: NSTimeInterval
    var delay: NSTimeInterval
    var xValue: CGFloat
    var yValue: CGFloat
    var textureName: String
    
    init(actsOn: PartType, actsOnSide: AnimSide, type: AnimType, duration: NSTimeInterval, delay: NSTimeInterval, xValue: CGFloat, yValue: CGFloat, textureName: String) {
        self.actsOn = actsOn
        self.type = type
        self.actsOnSide = actsOnSide
        
        switch(type) {
        case .scale:
            animation = SKAction.scaleXBy(xValue, y: yValue, duration: duration)
        case .rotation:
            animation = SKAction.rotateByAngle(xValue * π / 180.0, duration: duration)
        case .textureSwap:
            animation = SKAction.setTexture(SKTexture(imageNamed: textureName))
        case .position:
            animation = SKAction.moveBy(CGVector(dx: xValue, dy: yValue), duration: duration)
        }
        
        let delayAction = SKAction.waitForDuration(delay)
        animation = SKAction.sequence([delayAction, animation])
        
        self.duration = duration
        self.delay = delay
        self.xValue = xValue
        self.yValue = yValue
        self.textureName = textureName
        
        super.init()
    }
    
    /** Blank constructor to fill in the default vaules for an animation */
    override convenience init() {
        self.init(actsOn: .arm, actsOnSide: .left, type: .rotation, duration: 0, delay: 0, xValue: 0, yValue: 0, textureName: "")
    }
    
    /**
     * Scale a part type by the specified amount.
     */
    class func scalePart(actsOn: PartType, actsOnSide: AnimSide, duration: NSTimeInterval, delay: NSTimeInterval, scaleXBy: CGFloat, scaleYBy: CGFloat) -> MCAnimationComp {
        return MCAnimationComp(actsOn: actsOn,
                           actsOnSide: actsOnSide,
                                 type: .scale,
                             duration: duration,
                                delay: delay,
                               xValue: scaleXBy,
                               yValue: scaleYBy,
                          textureName: "")
    }
    
    /**
     * Rotate a part type by the specified amount.  "angle" is in DEGREES, not radians.
     */
    class func rotatePart(actsOn: PartType, actsOnSide: AnimSide, duration: NSTimeInterval, delay: NSTimeInterval, angle: CGFloat) -> MCAnimationComp {
        return MCAnimationComp(actsOn: actsOn,
                           actsOnSide: actsOnSide,
                                 type: .rotation,
                             duration: duration,
                                delay: delay,
                               xValue: angle,
                               yValue: 0,
                          textureName: "")
    }
    
    /**
     * Move a part type by the specified amount.
     */
    class func movePart(actsOn: PartType, actsOnSide: AnimSide, duration: NSTimeInterval, delay: NSTimeInterval, moveXBy: CGFloat, moveYBy: CGFloat) -> MCAnimationComp {
        return MCAnimationComp(actsOn: actsOn,
                           actsOnSide: actsOnSide,
                                 type: .position,
                             duration: duration,
                                delay: delay,
                               xValue: moveXBy,
                               yValue: moveYBy,
                          textureName: "")
    }
    
    /**
     * Change the texture of a part type to the specified texture for a specified amount of time
     */
    class func swapTexture(actsOn: PartType, actsOnSide: AnimSide, duration: NSTimeInterval, delay: NSTimeInterval, newTexture: String) -> MCAnimationComp {
        return MCAnimationComp(actsOn: actsOn,
                           actsOnSide: actsOnSide,
                                 type: .textureSwap,
                             duration: duration,
                                delay: delay,
                               xValue: 0,
                               yValue: 0,
                          textureName: newTexture)
    }
    
    func shortenFloat(number: CGFloat) -> String {
        return String(format: "%.3f", number)
    }
    
    func shortenDouble(number: Double) -> String {
        return String(format: "%.3f", number)
    }
    
    func description() -> String {
        var result = "Duration( \(shortenDouble(duration)) ) Delay( \(shortenDouble(delay)) ) : "
        
        switch(type) {
        case .scale:
            result += "Scale X( \(shortenFloat(xValue)) ) Y( \(shortenFloat(yValue)) )"
        case .rotation:
            result += "Rotate( \(shortenFloat(xValue))˚ )"
        case .position:
            result += "Move X(\(shortenFloat(xValue))) Y(\(shortenFloat(yValue)))"
        case .textureSwap:
            result += "Change Texture(\(textureName))"
        }
        
        return result
    }
}

/****
 * Enum to specify if an animation affects the right/left/both sides.
 *
 *  'bothNoMirror' means that both sides are affected, but rotations are
 *  not reversed in angle for the mirrored part.
 */
enum AnimSide: Int {
    case left = 0, right, both, bothNoMirror
}

/****
 * Enum that describes the different kind of animations you can make
 */
enum AnimType: Int {
    case scale = 0, rotation, position, textureSwap
}