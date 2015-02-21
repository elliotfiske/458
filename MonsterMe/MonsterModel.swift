//
//  MonsterModel.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation
import CoreData

class MonsterModel: NSManagedObject {

    @NSManaged var creationTime: NSDate
    @NSManaged var creatorName: String
    @NSManaged var editTime: NSDate
    
    @NSManaged var name: String
    @NSManaged var partData: NSData  // An array of MCParts stored via NSCoder
    @NSManaged var previewImage: NSData
    
    @NSManaged var trait1: NSNumber
    @NSManaged var trait2: NSNumber
    @NSManaged var trait3: NSNumber
    
    @NSManaged var uuid: String  // Unique identifier for fetching this monster from core data
    
    @NSManaged var voiceAccent: NSNumber

    /**
     * Dictionary of parts!  Note the access pattern:
     *
     * If I want all the arms, I simply enter 'parts[PartType.arm]' and it will retrieve
     *  all the arms on this monster.  How handy!
     */
    var parts: [PartType: [MCPart]]

}
