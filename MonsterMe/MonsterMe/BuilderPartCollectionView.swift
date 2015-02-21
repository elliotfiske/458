//
//  BuilderPartCollectionView.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

class BuilderPartCollectionView: DraggableCollectionView {
    
    var bodyPartDict: [PartType : [MCPartTemplate]] = [:]
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        readMonsterBodyProperties("bodyParts")
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
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

        var error: NSError?
        
        var filepath: String = NSBundle.mainBundle().pathForResource(fileName, ofType: "json")!
        
        var JSONData = NSData(contentsOfFile: filepath, options: NSDataReadingOptions.DataReadingMapped, error: &error)!
        if error != nil {
            println("Error reading body parts json data! \(error?.description)")
        }
        
        let dict: Dictionary<String,NSObject> = NSJSONSerialization.JSONObjectWithData(JSONData, options: nil, error: &error) as Dictionary<String, NSObject>
        if error != nil {
            println("Error parsing body parts json data! \(error?.description)")
        }
        
        for (key, value) in dict {
            // Each "key" represents a type of body part we're reading in from the JSON
            let partType = PartType(rawValue: key)!
            let partJSONArray = value as NSArray
            var partArray = [MCPartTemplate]()
            
            for part in partJSONArray {
                partArray.append(MCPartTemplate.templateFromJSON(part as Dictionary, type: partType))
            }
            
            bodyPartDict[partType] = partArray
        }
        
        return bodyPartDict
    }
}