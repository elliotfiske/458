//
//  AnimPreviewController.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/13/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import UIKit
import SpriteKit

class AnimPreviewController: UIViewController {
    var animatorModel: AnimatorModel!
    var previewScene: MonsterPreviewScene!
    
    override func viewDidLoad() {
        animatorModel = AnimatorModel(controller: self)
        
        // Change the view to our own custom SKView
        var currView = self.view as MonsterPreviewSKView
        currView.backgroundColor = UIColor.blueColor()
        
        previewScene = MonsterPreviewScene(size: self.view.frame.size)
        previewScene.monNode = animatorModel.monModel.body
        currView.presentScene(previewScene)
    }
}

/** Had to override this to get storyboard to have SKView in a view controller */
class MonsterPreviewSKView: SKView {
    
}

class MonsterPreviewScene: SKScene {
    // Global handle to the array of animations playing on the monster
    private struct CurrAnim { static weak var currAnim: MCAnimation? = nil }
    class var currAnim: MCAnimation? {
        get { return CurrAnim.currAnim }
        set { CurrAnim.currAnim = newValue }
    }
    
    var monNode: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        monNode.position = view.frame.center
        self.addChild(monNode)
        
        // Repeat action forever: Run the actions in MCAnimation, then call resetAnimation
    }
}