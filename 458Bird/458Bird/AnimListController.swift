
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
    
    override func viewDidLoad() {
        // TODO: Register cell for reuse (maybe?)
    }
    
    override func viewDidAppear(animated: Bool) {
        editAnimIndex = nil
        self.tableView.reloadData()
        let lel = Animation.createEntity() as Animation
        let anims = Animation.findAll() as [Animation]
    }
    
    /**** TABLE VIEW STUFF ****/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let anim = MonsterPreviewScene.currAnim {
            return anim.comps.count
        }
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        if let anim = MonsterPreviewScene.currAnim {
            cell.textLabel!.text = anim.comps[indexPath.row].description
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
            let newComp = MCAnimationComp()
            MonsterPreviewScene.currAnim!.comps += [newComp]
            maker.currAnimationRow = MonsterPreviewScene.currAnim!.comps.count - 1
        }
    }
    
    
    
    /** Suppress a dumb swift-style error */
    override func isEqual(anObject: AnyObject?) -> Bool {
        return super.isEqual(anObject)
    }
}