//
//  AnimationDetails.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/16/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import CoreData

class AnimationDetails: NSManagedObject {

    @NSManaged var image: String
    @NSManaged var note: String
    @NSManaged var length: NSNumber
    @NSManaged var animation: NSManagedObject

}
