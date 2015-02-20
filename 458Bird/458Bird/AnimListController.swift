
//
//  AnimListController.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/11/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import UIKit

class AnimListController: UITableViewController, UITableViewDelegate, UITableViewDataSource {
    /** Which animation component are we editing?  If nil, it's a new one. */
    var editAnimIndex: Int? = nil
    
    var savedAnimation: Animation!
    // If we just came back from editing a step, this will be the one we're inserting into the animation's set
    var newlyCreatedStep: AnimationStep?
    
    /**
     * Check if there's a saved animation in CoreData, and set it to
     *  our instance variable if there is.
     */
    override func viewDidLoad() {
        var savedAnimations = Animation.findAll()
        if savedAnimations.count != 0 {
            savedAnimation = savedAnimations.first as Animation
        }
    }
    
    /** 
     * Load all the cool animation details from the instance variable!
     * Make a new Animation object to save if there's not one already.
     */
    override func viewDidAppear(animated: Bool) {
        editAnimIndex = nil
        self.tableView.reloadData()
        
        // If there's not already a saved animation, make a blank one here
        if (savedAnimation == nil) {
            savedAnimation = Animation.createEntity() as Animation
            var newAnimStep = AnimationStep.createEntity() as AnimationStep
            savedAnimation.animationDetails = NSSet(object: newAnimStep)
        }
        
        // Set the global animation to the one pulled from CoreData (or the new one we just made)
        MonsterPreviewScene.currAnim = savedAnimation
        
        // Is there a new animation step to add/modify?  Do that now!
        if newlyCreatedStep != nil {
            
        }
        
    }
    
    /**** TABLE VIEW STUFF ****/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let anim = MonsterPreviewScene.currAnim {
            return anim.animationDetails.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let anim = MonsterPreviewScene.currAnim {
            var animSteps = anim.animationDetails.allObjects as [AnimationStep]
            animSteps.sort { ($0.orderInArray as Int) < ($1.orderInArray as Int) }
            cell.textLabel!.text = animSteps[indexPath.row].description
        }

        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        editAnimIndex = indexPath.row
        performSegueWithIdentifier("editAnimation", sender: nil)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Figure out what animation the user will be editing!
        let maker = segue.destinationViewController as AnimMakerController
        if let ndx = editAnimIndex {
            maker.currAnimationRow = ndx
        }
        else {
            // User actually clicked the ADD button!  How exciting.  Let's make a new animation step and add it to the current animation.
            let newStepIndex = MonsterPreviewScene.currAnim!.animationDetails.count - 1
            var newStep = AnimationStep.createEntity() as AnimationStep
            newStep.orderInArray = newStepIndex
            
            var animStepSet = MonsterPreviewScene.currAnim!.mutableSetValueForKey("animationDetails")
            animStepSet.addObject(newStep)
            MonsterPreviewScene.currAnim!.animationDetails = animStepSet
            maker.currAnimationRow = newStepIndex
        }
    }
    
    
    
    /** Suppress a dumb swift-style error */
    override func isEqual(anObject: AnyObject?) -> Bool {
        return super.isEqual(anObject)
    }
}