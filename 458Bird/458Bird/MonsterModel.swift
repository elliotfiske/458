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
    
    //    /** NOTE: DON'T break MVC by accessing methods on this property!
    //     *   The only reason it's here is because we need to know the body 'type'
    //     *   for saving, loading, and the image preview generation. */
    var body: MCPartBody
    
    var bodyColor: UIColor
    var currDecalColor: UIColor // What color should a decal be by default
    
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
    init(newBody: MCPartBody) {
        body = newBody
        
        parts = [
            PartType.arm:[],
            PartType.leg:[],
            PartType.decal:[],
            PartType.eye:[],
            PartType.mouth:[]
        ]
        
        // Set body and last decal to random colors
        let colors = MonsterDataReader.parts[.color]!.map { $0.color }
        bodyColor = colors.randomItem()
        currDecalColor = colors.randomItem()
        
        super.init()
    }
    
    /**
    * The view asked us what it should do for this frame.
    */
    func doUpdate() {
        // Figure out idle animations here
    }
    
    /**
    * Execute the specified MonsterAnimation
    */
//    func doAnimation(anim: MonsterAnimation) {
//        
//    }
    
    /**
    * Remove a specified part from the monster model
    */
    func doPartRemove(part: MCPart) {
        
    }
    
    /**
    * Add the speicifed part to the monster model
    */
    func doPartAdd(part: MCPart) {
        
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