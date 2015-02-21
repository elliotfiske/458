//
//  BuilderScene.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation
import SpriteKit

class BuilderScene: SKScene {
    var controller: CreatorViewController!
    var rotator = PartRotatorNode()
    
    var monsterNode: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        addChild(rotator)
        addChild(monsterNode)
        
        monsterNode.position = view.center
    }
    
    override func update(currentTime: NSTimeInterval) {
        controller.handleSceneUpdate()
    }
    
    /** Touches are passed in via an unwieldy NSSet.  Just grab the first touch from there. */
    func getFirstTouch(touches: NSSet) -> CGPoint {
        return (touches.allObjects[0] as UITouch).locationInNode(self)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        let touch = getFirstTouch(touches)
        controller.handleSceneTouchBegin(touch)
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        let touch = getFirstTouch(touches)
        controller.handleSceneTouchMoved(touch)
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        let touch = getFirstTouch(touches)
        controller.handleSceneTouchEnded(touch)
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        println("Touches are getting cancelled! That usually means something is wrong.  Just lettin' ya know.")
    }
}
