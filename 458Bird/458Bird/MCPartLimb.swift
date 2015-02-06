//
//  MCPartLimb.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/5/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//
//  Defines some custom behavior unique to arms and legs.

import Foundation
import SpriteKit

class MCPartLimb: MCPart {
    /**
     * Limbs fly radially away from the center of the monster
     */
    override func animateDetatchFromMonster() {
        let length = position.distanceTo(point: CGPointZero)
        let scaleFactor = 100.0 / length
        let direction = position * scaleFactor
        
        lockPoint = position + direction
    }
}