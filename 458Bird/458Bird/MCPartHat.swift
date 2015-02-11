//
//  MCPartHat.swift
//  MonsterAnim
//
//  Created by Andrew Adriance on 10/14/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartHat: MCPart {
    
    override init(textureName: String, color: UIColor, anchor: CGPoint) {
        super.init(textureName: textureName, color: color, anchor: anchor)
        minScale = 0.1
    }
    
    override var partType: PartType {
        return .decal
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
