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
    
    var topBar: CreatorNavigationBar!
    var backgroundView: UIView!
    var backgroundImage: UIImage!
    
    @IBOutlet weak var monsterSKView: SKView!
    var builderScene: BuilderScene!
    var currCreatorView: MCDismissableView!
    
    var currMonster: MonsterModel!
    var builderModel = BuilderModel()
    
    @IBOutlet weak var partCollectionView: UICollectionView!

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
    

    /**
     * Init and connect up all the models and views
     */
    override func viewDidLoad() {
        let screenRect = UIScreen.mainScreen().bounds
        monsterSKView.allowsTransparency = true
        
        builderScene = BuilderScene(size: screenRect.size)
        builderScene.controller = self
        builderScene.monsterNode = currMonster.body
        builderScene.backgroundColor = UIColor.clearColor()
        builderScene.scaleMode = .ResizeFill
        monsterSKView.presentScene(builderScene)
        
        builderModel.sceneNode = builderScene
        builderModel.monsterModel = currMonster
        builderModel.rotator = builderScene.rotator
        
        partCollectionView.dataSource = builderModel
        partCollectionView.delegate = builderModel
    }
    
    override func viewDidAppear(animated: Bool) {
        
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
    
    /**
     * The view just asked for a collection view cell.  Ask the model where
     */
    func getCollectionViewCell() {
        
    }
    
    func showPartBuilderView() {
        
    }
    
    func showTraitView() {
        
    }
    
    func showVoiceView() {
        
    }
    
    func showNameView() {
        
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}