//
//  MCPartColor.swift
//  MonsterAnim
//
//  Created by Elliot Fiske on 12/11/14.
//  Copyright (c) 2014 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class MCPartColor: MCPart {
    
    /** 
     * Whether or not this color is dragged onto a body part + is
     *   coloring a monster.
     */
    var coloringPart: Bool = false
    /**
     * The color that this 'part' will change the monster to when
     *  it is dragged onto the monster
     */
    var coloringColor: UIColor
    
    override init(textureName: String, color: UIColor, anchor: CGPoint) {
        coloringColor = color
        
        super.init(textureName: textureName, color: color, anchor: anchor)
    
        self.colorBlendFactor = 1.0
    }
    
    convenience init(color: UIColor) {
        self.init(textureName: "circle-TODO", color: color, anchor: CGPoint(x: 0.5, y: 0.5))
    }

    
    /** We don't change the color of the 'color part' when it's being dragged on */
    override func setColorNotColliding() {
        // do nothinggg
    }
    
    override func setColorColliding() {
        // do nuffin
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}