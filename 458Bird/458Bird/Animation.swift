//
//  Animation.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import CoreData

class Animation: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var id: NSNumber
    @NSManaged var animationDetails: NSSet
    
    var totalDuration: NSTimeInterval {
        get {
            var result: NSTimeInterval = 0
            for step in animationDetails.allObjects as! [AnimationStep] {
                if (step.duration as Double) + (step.delay as Double) > result {
                    result = (step.duration as Double) + (step.delay as Double)
                }
            }
            return result
        }
    }

}
