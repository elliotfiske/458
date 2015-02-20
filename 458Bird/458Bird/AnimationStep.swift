//
//  AnimationStep.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import CoreData

class AnimationStep: NSManagedObject {

    @NSManaged var actsOn: String
    @NSManaged var actsOnSide: NSNumber
    @NSManaged var animType: NSNumber
    @NSManaged var duration: NSNumber
    @NSManaged var delay: NSNumber
    @NSManaged var xValue: NSNumber
    @NSManaged var yValue: NSNumber
    @NSManaged var textureName: String
    @NSManaged var orderInArray: NSNumber
    @NSManaged var animation: Animation

}
