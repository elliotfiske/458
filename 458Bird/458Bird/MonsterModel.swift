//
//  MonsterModel.swift
//  MonsterAnim
//
//  Created by Elliot Fiske on 1/23/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//
//   Welcome to our first foray into MVC!  The MonsterModel handles ALL THE LOGIC
//    involved with the monster.  It takes care of saving and loading, does animations... and stuff.
//

import Foundation
import UIKit

class MonsterModel: NSObject, NSCoding {
    /** Every part on the monster, organized by part type */
    var parts: [PartType: [MCPart]]
    
    /** NOTE: DON'T break MVC by accessing methods on this property!
     *   The only reason it's here is because we need to know the body 'type'
     *   for saving, loading, and the image preview generation. */
    var body: MCPartBody
    
    var bodyColor: UIColor
    
    var uuid: String? // ID used to save/load monster
    var monsterName = "NAME"
    
    var canIdle = false
    var isExpanded = false // True when swapping bodies
    var isTalking = false
    
//    var monsterTraits: [MonsterTrait] = []
    var monsterAccent: String = "FURAME"
    
    /**
    * Initializes a blank monster
    */
    init(newBody: MCPartBody, bodyColor: UIColor) {
        body = newBody
        
        parts = [
            PartType.arm:[],
            PartType.leg:[],
            PartType.decal:[],
            PartType.eye:[],
            PartType.mouth:[]
        ]
        
        self.bodyColor = bodyColor
        
        super.init()
    }
    
    /**
    * The view asked us what it should do for this frame.
    */
    func doUpdate() {
        // Figure out idle animations here I guess?
    }
    
    /**
     * Execute the specified MCAnimationComp
     */
    func doAnimation(anim: MCAnimationComp) {
        // Check which part 
    }
    
    /**
     * Reset the monster's parts to default rotation, scale, position
     */
    func resetAnimations() {
        
    }
    
    /**
     * Remove a specified part from the monster model
     */
    func removePart(part: MCPart) {
        
    }
    
    /**
     * Add the specified part to the monster model
     */
    func addPart(part: MCPart) {
        parts[part.partType]!.append(part)
        body.addChild(part)
    }
    
    /**
    * Take a mugshot of the monster we can use to preview the monster
    */
    func renderPreview() -> UIImage {
        return UIImage()
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("I'll get to this!  yessss")
        // TODO: init monster here lol
    }
    
    func encodeWithCoder(aCoder: NSCoder) {
        // TODO: do it lol
    }
    
    
    
}