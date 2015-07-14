//
//  MCPartBody.swift
//  MonsterAnim
//
//  Created by Elliot Fiske on 1/26/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartBody: SKSpriteNode {

    var node: SKSpriteNode
    
    override init(texture: SKTexture, color: UIColor!, size: CGSize) {
        node = SKSpriteNode()
        super.init(texture: texture, color: color, size: size)
        node = self
    }
    
    convenience init() {
        self.init(texture: SKTexture(imageNamed: "monsterBody"), color: UIColor.purpleColor(), size: CGSize(width: 100, height: 100))
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}