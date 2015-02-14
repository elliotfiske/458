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
    let partTypes: [PartType] = [.arm, .leg, .base, .eye, .decal, .mouth, .hat]
    
    var currAnimation = MCAnimationComp()
    
    @IBOutlet weak var valueSlider: UISlider!
    @IBOutlet weak var durationSlider: UISlider!
    @IBOutlet weak var delaySlider: UISlider!
    @IBOutlet weak var typeSegControl: UISegmentedControl!
    
    @IBOutlet weak var minValueLabel: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    
    @IBOutlet weak var howMuchLabel: UILabel!
    @IBOutlet weak var durationLabel: UILabel!
    @IBOutlet weak var delayLabel: UILabel!
    
    override func viewDidAppear(animated: Bool) {
        valueSlider.setValue(0, animated: true)
        durationSlider.setValue(0, animated: true)
        delaySlider.setValue(0, animated: true)
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
        currAnimation.actsOn = partTypes[row]
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
        if let segControl = sender as? UISegmentedControl {
            currAnimation.actsOnSide = AnimSide.animSideFromIndex(segControl.selectedSegmentIndex)
        }
        
        animationFromSliders()
    }
    
    
    /*** SILLY SLIDERS ***/
    @IBAction func changedValue(sender: AnyObject) {
        howMuchLabel.text = (sender as? UISlider)!.value.description
    }
    
    @IBAction func changedDuration(sender: AnyObject) {
        durationLabel.text = (sender as? UISlider)!.value.description
    }
    
    @IBAction func changedDelay(sender: AnyObject) {
        delayLabel.text = (sender as? UISlider)!.value.description
    }
    
    /**
     * Updates the currAnimation property with values pulled from the different value sliders
     */
    func animationFromSliders() {
        var delayAction: SKAction
        var animAction = SKAction.waitForDuration(NSTimeInterval(delaySlider.value))
    
        var animValue = CGFloat(valueSlider.value)
        var duration = NSTimeInterval(durationSlider.value)
        
        switch (typeSegControl.selectedSegmentIndex) {
        case 0:
            currAnimation.animation = SKAction.scaleBy(animValue, duration: duration)
        case 1:
            currAnimation.animation = SKAction.rotateByAngle(animValue, duration: duration)
        case 2:
            currAnimation.animation = SKAction.setTexture(SKTexture(imageNamed: "lol this isn't ready yet plz"))
        case 3:
            currAnimation.animation = SKAction.moveByX(0, y: 0, duration: 0)
        default:
            println("Somehow chose an animation type that doesn't exist..?!? (animationFromSliders)")
        }
    }
    
    
}