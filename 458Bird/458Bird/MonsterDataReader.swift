//
//  MonserDataReader.swift
//  MonsterAnim
//
//  Created by Kyle Piddington on 6/25/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

class MonsterDataReader {
    
    /** Global handle to the monster parts dicitonary.  Hopefully one of the few globals that we have to use! */
    private struct MonsterParts { static var parts: Dictionary<PartType, [MCPartTemplate]>? }
    class var parts: Dictionary<PartType, [MCPartTemplate]> {
        get {
            if MonsterParts.parts == nil {
                MonsterParts.parts = readMonsterBodyProperties("bodyParts")
            }
            
            return MonsterParts.parts!
        }
    }
}

/**
 * Read in the body parts we want from the JSON data.
 * The final result will look like this:
 *
 * {
 *   PartType.eye   : [EyeTemplate1, EyeTemplate2, EyeTemplate3, ... ]
 *   PartType.mouth : [MouthTemplate1, MouthTemplate2, MouthTemplate3, ...]
 *    ...
 *    etc. for all the part types
 * }
 */
func readMonsterBodyProperties(fileName: String) -> Dictionary<PartType, [MCPartTemplate]> {
    var bodyPartDict: [PartType : [MCPartTemplate]] = [:]
    var error: NSError?
    
    var filepath: String = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")!
    
    var JSONData = NSData(contentsOfFile: filepath, options: NSDataReadingOptions.DataReadingMapped, error: &error)!
    if error != nil {
        println("Error reading body parts json data! \(error?.description)")
    }
    
    let swiftObject: Dictionary<String,NSObject> = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) as Dictionary<String, NSObject>
    if error != nil {
        println("Error parsing body parts json data! \(error?.description)")
    }
    
    var dict = swiftObject
    for (key, value) in swiftObject {
        // Each "key" represents a type of body part we're reading in from the JSON
        let partType = PartType(rawValue: key)!
        let partJSONArray = value as NSArray
        var partArray = [MCPartTemplate]()
        var i = 0
        for part in partJSONArray {
            partArray.append(MCPartTemplate.partFromJSON(part as Dictionary, type: partType, index:i))
            i++
        }
        
        bodyPartDict[partType] = partArray
    }
    
    return bodyPartDict
}