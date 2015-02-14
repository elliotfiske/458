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
}

class MCAnimationComp: NSObject {
    var actsOn: PartType
    /** Does this animation affect the right, left, or both sides of the monster? */
    var actsOnSide: AnimSide
    var animation: SKAction
    
    init(actsOn: PartType, actsOnSide: AnimSide, animations: SKAction) {
        self.actsOn = actsOn
        self.animation = animations
        self.actsOnSide = actsOnSide
        super.init()
    }

    convenience override init() {
        self.init(actsOn: .arm, actsOnSide: .both, animations: SKAction())
    }
}

/****
 * Enum to specify if an animation affects the right/left/both sides.
 *
 *  'bothNoMirror' means that both sides are affected, but rotations are
 *  not reversed in angle for the mirrored part.
 */
enum AnimSide {
    case left, right, both, bothNoMirror
    
    static func animSideFromIndex(index: Int) -> AnimSide {
        switch(index) {
        case 0:
            return .left
        case 1:
            return .right
        case 2:
            return .both
        case 3:
            return .bothNoMirror
        default:
            fatalError("Invalid index \(index) sent to animSideFromIndex")
        }
    }
}