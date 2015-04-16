//
//  AnimationStep.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import CoreData
import SpriteKit

class AnimationStep: NSObject {

    var actsOn: PartType
    var actsOnSide: AnimSide
    var animType: AnimType
    var duration: NSTimeInterval
    var delay: NSTimeInterval
    var xValue: CGFloat?
    var yValue: CGFloat?
    var textureName: String?
    weak var animation: Animation?
    
    init(actsOn: PartType, actsOnSide: AnimSide, animType: AnimType, duration: NSTimeInterval, delay: NSTimeInterval) {
        self.actsOn = actsOn
        self.actsOnSide = actsOnSide
        self.animType = animType
        self.duration = duration
        self.delay = delay
    }
    
    class func scaleStep(actsOn: PartType, actsOnSide: AnimSide,  duration: NSTimeInterval, delay: NSTimeInterval, xValue: CGFloat, yValue: CGFloat) -> AnimationStep {
        let step = AnimationStep(actsOn: actsOn, actsOnSide: actsOnSide, animType: .scale, duration: duration, delay: delay)
        step.xValue = xValue
        step.yValue = yValue
        
        return step
    }
    
    class func rotationStep(actsOn: PartType, actsOnSide: AnimSide,  duration: NSTimeInterval, delay: NSTimeInterval, rotation: CGFloat) -> AnimationStep {
        let step = AnimationStep(actsOn: actsOn, actsOnSide: actsOnSide, animType: .rotation, duration: duration, delay: delay)
        step.xValue = rotation
        
        return step
    }
    
    class func textureSwapStep(actsOn: PartType, actsOnSide: AnimSide,  duration: NSTimeInterval, delay: NSTimeInterval, textureName: String) -> AnimationStep {
        let step = AnimationStep(actsOn: actsOn, actsOnSide: actsOnSide, animType: .textureSwap, duration: duration, delay: delay)
        step.textureName = textureName
        
        return step
    }
    
    class func positionStep(actsOn: PartType, actsOnSide: AnimSide,  duration: NSTimeInterval, delay: NSTimeInterval, xValue: CGFloat, yValue: CGFloat) -> AnimationStep {
        let step = AnimationStep(actsOn: actsOn, actsOnSide: actsOnSide, animType: .position, duration: duration, delay: delay)
        step.xValue = xValue
        step.yValue = yValue
        
        return step
    }
    
    /**
     * Generates the SKAction that corresponds to this animation step.
     */
    func generateSKAction() -> SKAction {
        switch (animType) {
        case .scale:
            return SKAction.scaleXBy(xValue!, y: yValue!, duration: duration)
        case .rotation:
            return SKAction.rotateByAngle(xValue! * π / 180.0, duration: duration)
        case .textureSwap:
            let changeStep = SKAction.setTexture(SKTexture(imageNamed: textureName!))
            return changeStep
        case .position:
            return SKAction.moveBy(CGVector(dx: xValue!, dy: yValue!), duration: duration)
        default:
            println("Somehow chose an animation type that doesn't exist..?!? (generateSKAction)")
        }
    }
}
