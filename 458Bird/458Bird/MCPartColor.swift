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

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /** We don't change the color of the 'color part' when it's being dragged on */
    override func setColorNotColliding() {
        // do nothinggg
    }
    
    override func setColorColliding() {
        // do nuffin
    }
}