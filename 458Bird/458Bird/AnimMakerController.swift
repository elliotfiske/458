//
//  AnimMakerController.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/12/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import UIKit

class AnimMakerController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let partTypes = ["arm", "leg", "body", "eye", "decal", "mouth", "base", "hat"]
    
    /** Values that the user chooses in the Animation Maker */
    var actsOnType: PartType = .arm
    var actsOnSide: AnimSide = .left
    var value: CGFloat = 0
    var duration: NSTimeInterval = 0
    var delay: NSTimeInterval = 0
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return partTypes.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: partTypes[row])
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
}