//
//  Animation.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import CoreData

class Animation: NSObject {

    var animationDetails: [AnimationStep] = []
    
    var totalDuration: NSTimeInterval {
        get {
            var result: NSTimeInterval = 0
            for step in animationDetails {
                if (step.duration as Double) + (step.delay as Double) > result {
                    result = (step.duration as Double) + (step.delay as Double)
                }
            }
            return result
        }
    }

}
