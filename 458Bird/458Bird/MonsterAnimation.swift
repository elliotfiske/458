//
//  MonsterAnimation.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/28/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import SpriteKit

class MonsterAnimation: NSObject {
    let actsOn: PartType
    /** Does this animation affect the right, left, or both sides of the monster? */
    let actsOnSide: AnimSide
    let animation: SKAction
    
    init(actsOn: PartType, actsOnSide: AnimSide, animations: SKAction) {
        self.actsOn = actsOn
        self.animation = animations
        self.actsOnSide = actsOnSide
        super.init()
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
}