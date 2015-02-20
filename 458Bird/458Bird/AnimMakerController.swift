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
    
    var currAnimationRow: Int!
    var currStep: AnimationStep!
    
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
        var currAnimationSteps = MonsterPreviewScene.currAnim!.animationDetails.allObjects as [AnimationStep]
        currAnimationSteps.sort { ($0.orderInArray as Int) < ($1.orderInArray as Int) }
        let currStep = currAnimationSteps[currAnimationRow]
        
        var partTypeIndex = 0
        for (ndx, partType) in enumerate(partTypes) {
            if partType.rawValue == currStep.actsOn {
                partTypeIndex = ndx
            }
        }
        partTypePicker.selectRow(partTypeIndex, inComponent: 0, animated: false)
        typeSegControl.selectedSegmentIndex = currStep.animType as Int
        valueSlider.setValue(Float(currStep.xValue), animated: true)
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
            switch(segControl.selectedSegmentIndex) {
            /** SCALE **/
            case 0:
                valueSlider.minimumValue = -2
                valueSlider.maximumValue = 2
                
            /** ROTATION **/
            case 1:
                valueSlider.minimumValue = -360
                valueSlider.maximumValue = 360
                
            /** SWAP TEXTURE (NOT DONE) **/
            case 2:
                valueSlider.minimumValue = 0
                valueSlider.maximumValue = 0
                
            /** POSITION (NOT DONE) **/
            case 3:
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
     * Updates the currAnimation property with values pulled from the different value sliders
     */
    func updateCurrAnimation() {
        var animAction = SKAction.waitForDuration(NSTimeInterval(delaySlider.value))

//        valueSlider.setValue(Float(valueLabel.text.), animated: false)
        
        var type = partTypes[partTypePicker.selectedRowInComponent(0)]
        var side = AnimSide(rawValue: typeSegControl.selectedSegmentIndex)!

        var duration = NSTimeInterval(durationSlider.value)
        var delay = NSTimeInterval(delaySlider.value)
        
        var howMuch = CGFloat(valueSlider.value)
        var howMuchY: CGFloat = 1.0
        
        switch (typeSegControl.selectedSegmentIndex) {
        case 0:
            MonsterPreviewScene.currAnim!.animationDetails. = MCAnimationComp.scalePart(type, actsOnSide: side, duration: duration, delay: delay, scaleXBy: howMuch, scaleYBy: howMuchY)
        case 1:
            MonsterPreviewScene.currAnim!.comps[currAnimationRow] = MCAnimationComp.rotatePart(type, actsOnSide: side, duration: duration, delay: delay, angle: howMuch)
        case 2:
            MonsterPreviewScene.currAnim!.comps[currAnimationRow] = MCAnimationComp.swapTexture(type, actsOnSide: side, duration: duration, delay: delay, newTexture: "lol not done")
        case 3:
            MonsterPreviewScene.currAnim!.comps[currAnimationRow] = MCAnimationComp.movePart(type, actsOnSide: side, duration: duration, delay: delay, moveXBy: howMuch, moveYBy: howMuchY)
        default:
            println("Somehow chose an animation type that doesn't exist..?!? (animationFromSliders)")
        }
    }
}