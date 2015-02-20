//
//  Animation.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/16/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import CoreData

class Animation: NSManagedObject {

    @NSManaged var name: String
    @NSManaged var animationDetails: AnimationDetails

}
