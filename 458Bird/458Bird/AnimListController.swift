
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
    
    override func viewDidLoad() {
        // TODO: Register cell for reuse
    }
    
    
    /**** TABLE VIEW STUFF ****/
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    
    
    /** Suppress a dumb swift-style error */
    override func isEqual(anObject: AnyObject?) -> Bool {
        return super.isEqual(anObject)
    }
}