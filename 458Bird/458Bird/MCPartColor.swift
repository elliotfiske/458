//
//  MCPartColor.swift
//  MonsterAnim
//
//  Created by Elliot Fiske on 12/11/14.
//  Copyright (c) 2014 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartColor : MCPart {
    /** 
     * Whether or not this color is dragged onto a body part + is
     *   coloring a monster.
     */
    var coloringPart: Bool = false
    var color: UIColor {
        return (self.partTemplate as MCTemplateColor).color
    }
    
    override init(aNode: SKSpriteNode, template: MCPartTemplate) {
        super.init(aNode: aNode, template: template)
    
        self.node.color = (template as MCTemplateColor).color
        self.node.colorBlendFactor = 1.0
//        self.node.physicsBody!.categoryBitMask = colorCategory
        
        self.deselectForCollision()
    }
    
//    /** The color "part" shouldn't ever change colors, that wouldn't make sense. */
//    override func setTentativeColor(newColor: UIColor) {
//        // do nothing lol
//    }
//    override func restoreColor() {
//        // do nothing lol
//    }
//    override func changeColor(newColor: UIColor) {
//        // do nothign lol
//    }
//    
    override func setColorNotColliding() {
        // do nothinggg
    }
    
    override func setColorColliding() {
        // guess what.  do nothing.
    }
}