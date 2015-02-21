//
//  MonsterModel.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation
import CoreData

@objc(MonsterModel)
class MonsterModel: NSManagedObject {

    @NSManaged var creationTime: NSDate
    @NSManaged var creatorName: String
    @NSManaged var editTime: NSDate
    
    @NSManaged var trait1: NSNumber
    @NSManaged var trait2: NSNumber
    @NSManaged var trait3: NSNumber
    
    @NSManaged var voiceAccent: NSNumber
    
    @NSManaged var name: String
    
    /** An array of MCParts stored via NSCoder */
    @NSManaged var partData: NSData
    
    /** Unique identifier for fetching this monster from core data */
    @NSManaged var uuid: String
    
    @NSManaged var previewImage: NSData

    /**
     * Dictionary of parts!  Note the access pattern:
     *    If I want all the arms, I simply enter 'parts[PartType.arm]' and it will retrieve
     *    all the arms on this monster in an array.  How handy!
     */
    var parts: [PartType: [MCPart]] = [:]


//    override init(entity: NSEntityDescription, insertIntoManagedObjectContext context: NSManagedObjectContext?) {
//        parts = [
//            .arm:   [],
//            .leg:   [],
//            .decal: [],
//            .eye:   [],
//            .mouth: [],
//            .body:  []
//        ]
//    }
//    
    /**
     * Instantiate the parts variable from the saved NSData
     */
    func convertPartDataToParts() {
        
    }
}
