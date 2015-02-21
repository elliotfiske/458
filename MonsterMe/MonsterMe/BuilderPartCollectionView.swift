//
//  BuilderPartCollectionView.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

class BuilderPartCollectionView: DraggableCollectionView {
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
}