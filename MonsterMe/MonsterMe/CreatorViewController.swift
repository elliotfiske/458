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
    
    var topBar: BuilderNavigationBar!
    var backgroundView: UIView!
    var backgroundImage: UIImage!
    
    var builderScene: BuilderScene!
    var currCreatorView: MCDismissableViewController!
    var creatorViews: [MCDismissableViewController]!
    
    var currMonster: MonsterModel
    var builderModel = BuilderModel()
    
    /**
     * Instantiate a creator view controller with a brand spanking new monster
     */
    convenience override init() {
        var newMonster = MonsterModel.MR_createEntity() as MonsterModel
        newMonster.addRandomBody()
        self.init(monModel: newMonster)
    }
    
    /**
     * Instantiate a creator view controller containing the specified, existing monster
     */
    init(monModel: MonsterModel) {
        currMonster = monModel
        super.init(nibName: nil, bundle: nil)
    }
    

    override func loadView() {
        let screenRect = UIScreen.mainScreen().bounds
        let skView = SKView(frame: screenRect)
        skView.multipleTouchEnabled = false
        
        builderScene = BuilderScene(size: screenRect.size)
        builderScene.controller = self
        builderScene.monsterNode = currMonster.body
        skView.presentScene(builderScene)
        
        builderModel.sceneNode = builderScene
        builderModel.monsterModel = currMonster
        builderModel.rotator = builderScene.rotator
        
        self.view = skView
    }
    
    func handleSceneTouchBegin(touch: CGPoint) {
        builderModel.handleSceneTouchBegin(touch)
    }
    
    func handleSceneTouchMoved(touch: CGPoint) {
        builderModel.handleSceneTouchMoved(touch)
    }
    
    func handleSceneTouchEnded(touch: CGPoint) {
        builderModel.handleSceneTouchEnded(touch)
    }
    
    func handleSceneUpdate() {
        builderModel.handleSceneUpdate()
    }
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}