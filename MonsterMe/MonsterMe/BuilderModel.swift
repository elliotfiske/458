//
//  BuilderModel.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class BuilderModel: NSObject {
    var draggingPart: MCPart?
    
    var rotator: PartRotatorNode!
    
    var sceneNode: SKScene!
    weak var monsterModel: MonsterModel!
    
    var draggingRotator = false
    
    /**
     * User just touched the screen!  First, check if the user is dragging the
     *  part-rotator.  Then check if the user touched a part.  Otherwise
     *  deselect the current part (if any)
     */
    func handleSceneTouchBegin(touch: CGPoint) {
        draggingPart = nil
        
        if rotator.containsPoint(touch) {
            draggingRotator = true
            return
        }

        rotator.hideRotator()
        
        for part in monsterModel.allParts {
            if part.partType == .body {
                continue
            }
            
            if part.containsPoint(touch) { // TODO: have logic here for if parts are overlapping
                rotator.startRotatingPart(part)
            }
        }
    }
    
    /**
     * User dragged on the screen!  Move whatever they're dragging under their finger
     */
    func handleSceneTouchMoved(touch: CGPoint) {
        if draggingRotator {
            rotator.draggedToPoint(touch)
        }
        
        if draggingPart != nil {
            draggingPart!.dragPoint = touch
        }
    }

    /**
     * User released finger!  If they were dragging a part, see if we should attach it to the monster
     *  or just let it die.
     */
    func handleSceneTouchEnded(touch: CGPoint) {
        draggingRotator = false
        draggingPart = nil
    }
    
    /**
     * Called once a frame from the scene.  Go through each part and call partUpdate() on it
     */
    func handleSceneUpdate() {
        for eye in monsterModel.parts[.eye]! {
            eye.updatePart()
        }
    }
    
}