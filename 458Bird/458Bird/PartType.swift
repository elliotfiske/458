//
//  PartType.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/30/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation

/** An enum that keeps track of every kind a body part can be.
 *   Also has a few helper methods that categorize the different aspects of parts.
 *   'Color' is a part type since it's implemented as an MCBodyPart
 */
enum PartType: String {
    case arm = "arm"
    case leg = "leg"
    case body = "body"
    case eye = "eye"
    case eyeEmotion = "eyeEmotion"
    case decal = "decal"
    case mouth = "mouth"
    case base = "base"
    case hat = "hat"
    case legBase = "legBase"
    case color = "color"
    
    /** Determines if this part will be colored the same as the body by default. */
    func matchesBodyColor() -> Bool {
        switch(self) {
        case body, arm, leg:
            return true
        default:
            return false
        }
    }
    
    func displayName() -> String {
        switch (self) {
        case .arm:
            return "arms"
        case .leg:
            return "legs"
        case .mouth:
            return "mouths"
        case .decal:
            return "stuff"
        case .eye:
            return "eyes"
        default:
            return self.rawValue
        }
    }
}
