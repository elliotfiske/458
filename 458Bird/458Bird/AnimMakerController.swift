//
//  AnimMakerController.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/12/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class AnimMakerController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    let partTypes: [PartType] = [.arm, .leg, .base, .eye, .decal, .mouth]
    
    var currStep: AnimationStep!
    var animationListController: AnimListController!
    
    @IBOutlet weak var partTypePicker: UIPickerView!
    
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    
    @IBOutlet weak var valueLabel: UITextField!
    @IBOutlet weak var durationLabel: UITextField!
    @IBOutlet weak var delayLabel: UITextField!
    
    override func viewWillAppear(animated: Bool) {
        currStep = AnimationStep(actsOn: .arm, actsOnSide: .both, animType: .rotation, duration: 2.0, delay: 0.0)
        
        var partTypeIndex = 0
        for (ndx, partType) in enumerate(partTypes) {
            if partType == currStep.actsOn {
                partTypeIndex = ndx
            }
        }
        partTypePicker.selectRow(partTypeIndex, inComponent: 0, animated: false)
        typeSegControl.selectedSegmentIndex = currStep.animType.rawValue
        
        if currStep.xValue != nil {
            valueSlider.setValue(Float(currStep.xValue!), animated: true)
        }
        durationSlider.setValue(Float(currStep.duration), animated: true)
        delaySlider.setValue(Float(currStep.delay), animated: true)
        
        changedDelay(delaySlider)
        changedValue(valueSlider)
        changedDuration(durationSlider)
        pickedType(typeSegControl)
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return partTypes.count
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: partTypes[row].displayName())
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        println("selected row \(partTypes[row].displayName())!")
        updateCurrAnimation()
    }
    
    
    /**
     * User changed the type of animation (scale, pos, rot, etc.)
     *  Update slider values to reflect this
     */
    @IBAction func pickedType(sender: AnyObject) {
        if let segControl = sender as? UISegmentedControl {
            switch(AnimType(rawValue: segControl.selectedSegmentIndex)!) {
            case .scale:
                valueSlider.minimumValue = -2
                valueSlider.maximumValue = 2
            case .rotation:
                valueSlider.minimumValue = -360
                valueSlider.maximumValue = 360
            case .textureSwap:
                valueSlider.minimumValue = 0
                valueSlider.maximumValue = 0
            case .position:
                valueSlider.minimumValue = -20
                valueSlider.maximumValue = 20
                
            default:
                println("Somehow switched to a anim type that doesn't exist! (pickedType)")
            }
            
            valueSlider.setValue(0, animated: true)
            minValueLabel.text = valueSlider.minimumValue.description
            maxValueLabel.text = valueSlider.maximumValue.description
        }
    }
    
    /** Update the animation when the user chooses 'left/right/both' */
    @IBAction func pickedSide(sender: AnyObject) {
        updateCurrAnimation()
    }
    
    
    /*** SILLY SLIDERS ***/
    @IBAction func changedValue(sender: AnyObject) {
        var newValue = CGFloat((sender as? UISlider)!.value)
        valueLabel.text = newValue.description
        updateCurrAnimation()
    }
    
    @IBAction func changedDuration(sender: AnyObject) {
        durationLabel.text = (sender as? UISlider)!.value.description
        updateCurrAnimation()
    }
    
    @IBAction func changedDelay(sender: AnyObject) {
        delayLabel.text = (sender as? UISlider)!.value.description
        updateCurrAnimation()
    }
    
    /**
     * Updates the currStep property with values pulled from the different value sliders and pickers
     *
     * Also update the list of SKActions currently going on in the preview controller
     */
    func updateCurrAnimation() {
        var partType = partTypes[partTypePicker.selectedRowInComponent(0)]
        var side = AnimSide(rawValue: typeSegControl.selectedSegmentIndex)!
        
        var animType = typeSegControl.selectedSegmentIndex

        var duration = NSTimeInterval(durationSlider.value)
        var delay = NSTimeInterval(delaySlider.value)
        
        var howMuch = CGFloat(valueSlider.value)
        var howMuchY: CGFloat = 1.0
        
        currStep.actsOn = partType
        currStep.actsOnSide = side
        currStep.animType = AnimType(rawValue: animType)!
        currStep.duration = duration
        currStep.delay = delay
        currStep.xValue = howMuch
        // TODO: currstep.yvalue
        // TODO: currstep.textureName

        animationListController.updateCurrAnimation(currStep)
    }
}