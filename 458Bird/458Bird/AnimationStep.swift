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

class AnimationStep: NSManagedObject {

    @NSManaged var actsOn: String
    @NSManaged var actsOnSide: NSNumber
    @NSManaged var animType: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var delay: NSNumber
    @NSManaged var xValue: NSNumber
    @NSManaged var yValue: NSNumber
    @NSManaged var textureName: String
    @NSManaged var orderInArray: NSNumber
    @NSManaged var animation: Animation
    
    /**
     * Generates the SKAction that corresponds to this animation step.
     */
    func generateSKAction() -> SKAction {
        switch (AnimType(rawValue: animType as Int)!) {
        case .scale:
            return SKAction.scaleXBy(xValue as CGFloat, y: yValue as CGFloat, duration: duration as NSTimeInterval)
        case .rotation:
            return SKAction.rotateByAngle(xValue as CGFloat * π / 180.0, duration: duration as NSTimeInterval)
        case .textureSwap:
            return SKAction.setTexture(SKTexture(imageNamed: textureName))
        case .position:
            return SKAction.moveBy(CGVector(dx: xValue as CGFloat, dy: yValue as CGFloat), duration: duration as NSTimeInterval)
        default:
            println("Somehow chose an animation type that doesn't exist..?!? (generateSKAction)")
        }
    }
}
