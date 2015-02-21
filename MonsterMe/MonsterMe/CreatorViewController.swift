//
//  CreatorViewController.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//
//   This is the granddaddy of all the views you'll see in the creation screen.
//     Its child views look like:
//
//     - BackgroundUIView on the bottom
//     - Current 'Creation' View Controller (traits, parts, voice, etc.), which is a MCDismissableViewController
//     - MonsterEditController on top, which presents the monster in an SKScene over ALL these screens.
//
//     - TopNavigationBar wherever.  It doesn't care where it is in the heirarchy.

import Foundation
import UIKit
import SpriteKit

class CreatorViewController: UIViewController {
    var currPage: CreatorScreen = CreatorScreen(rawValue: 0)!
    
    var topBar: TopNavigationBar!
    var backgroundView: UIView!
    var backgroundImage: UIImage!
    
    var builderScene: BuilderScene!
    var currCreatorView: MCDismissableViewController!
    var creatorViews: [MCDismissableViewController]!
    
    var monsterEditController: MonsterEditController! // This is the controller that maintains the Monster throughout the screens
    
    var currMonster: MonsterModel
    
    /**
     * Instantiate a creator view controller with a brand spanking new monster
     */
    init() {
        currMonster = MonsterModel.MR_createEntity()
        currMonster.addRandomBody()
    }
    
    /**
     * Instantiate a creator view controller containing the specified, existing monster
     */
    init(monModel: MonsterModel) {
        currMonster = monModel
    }
    
    override func loadView() {
        let screenRect = UIScreen.mainScreen().bounds
        self.view = SKView(frame: screenRect)
        
        builderScene = BuilderScene()
    }
}