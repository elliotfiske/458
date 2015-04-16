
//
//  AnimListController.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/11/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class AnimListController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    /** Handle to the scene where the monster is flailing about */
    var previewController: AnimPreviewController!
    
    /** Which animation component are we editing?  If nil, it's a new one. */
    var editAnimIndex: Int? = nil
    
    /** If we just came back from editing a step, this will be the one we're inserting into the animation's set */
    var newlyCreatedStep: AnimationStep?
    var savedAnimation: Animation!
    
    /**
     * Check if there's a saved animation in CoreData, and set it to
     *  our instance variable if there is.
     */
    override func viewDidLoad() {
//        var savedAnimations = Animation.findAll()
//        if savedAnimations.count != 0 {
//            savedAnimation = savedAnimations.first as! Animation
//        }
//        else {
//            savedAnimation = Animation.createEntity() as! Animation
        savedAnimation = Animation()
//        }
        
        previewController = self.splitViewController!.viewControllers.first as! AnimPreviewController
    }
    
    /** 
     * Load all the cool animation details from the instance variable!
     * Make a new Animation object to save if there's not one already.
     */
    override func viewDidAppear(animated: Bool) {
        self.tableView.reloadData()
        
        // If there's not already a saved animation, make a blank one here
        if (savedAnimation == nil) {
            savedAnimation = Animation.createEntity() as! Animation
            var newAnimStep = AnimationStep.createEntity() as! AnimationStep
            savedAnimation.animationDetails = NSSet(object: newAnimStep)
        }
        
        // Is there a new animation step to add/modify?  Do that now!
        if let newStep = newlyCreatedStep {
            var animSteps = savedAnimation.animationDetails.allObjects as! [AnimationStep]
            animSteps.sort { ($0.orderInArray as Int) < ($1.orderInArray as Int) }
            
            animSteps[editAnimIndex!] = newStep
            savedAnimation.animationDetails = NSSet(array: animSteps)
        }
        
        editAnimIndex = nil
    }
    
    /**** TABLE VIEW STUFF ****/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let anim = savedAnimation {
            return anim.animationDetails.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let anim = savedAnimation {
            var animSteps = anim.animationDetails.allObjects as! [AnimationStep]
            animSteps.sort { ($0.orderInArray as Int) < ($1.orderInArray as Int) }
            let currStep = animSteps[indexPath.row]
            cell.textLabel!.text = currStep.description
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        editAnimIndex = indexPath.row
        performSegueWithIdentifier("editAnimation", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Figure out what animation the user will be editing!
        let maker = segue.destinationViewController as! AnimMakerController
        
        // editAnimIndex describes the index of the step we're editing - if it's nil,
        //  we're ADDING a new row, so set it one past the end of the current animation steps
        //  and add a new value to the animation step set
        if editAnimIndex == nil {
            editAnimIndex = savedAnimation.animationDetails.count - 1
            var newStep = AnimationStep.createEntity() as! AnimationStep
            
            var animStepSet = savedAnimation.mutableSetValueForKey("animationDetails")
            animStepSet.addObject(newStep)
            savedAnimation.animationDetails = animStepSet
        }
        
        maker.animationListController = self
    }
    
    /**
     * One of the animation's steps was modified.  Update our saved object
     *  and tell the preview scene what the new animation is.
     */
    func updateCurrAnimation(modifiedStep: AnimationStep) {
        var animSteps = savedAnimation.animationDetails.allObjects as! [AnimationStep]
        animSteps.sort { ($0.orderInArray as Int) < ($1.orderInArray as Int) }
        
        animSteps[editAnimIndex!] = modifiedStep
        savedAnimation.animationDetails = NSSet(array: animSteps)
        previewController.previewScene.currAnimation = savedAnimation
    }
    
    
    /** Suppress a dumb swift-style error */
    override func isEqual(anObject: AnyObject?) -> Bool {
        return super.isEqual(anObject)
    }
}