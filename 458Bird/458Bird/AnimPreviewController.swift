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
        
        let skSize = CGSize(width: view.frame.size.width, height: view.frame.size.height * 2)
        previewScene = MonsterPreviewScene(size: skSize)
        previewScene.monModel = animatorModel.monModel
        currView.presentScene(previewScene)
    }
}

/** Had to override this to get storyboard to have SKView in a view controller */
class MonsterPreviewSKView: SKView {
    
}

class MonsterPreviewScene: SKScene {
    // Global handle to the array of animations playing on the monster
    private struct CurrAnim { static var currAnim: MCAnimation? = nil }
    class var currAnim: MCAnimation? {
        get { return CurrAnim.currAnim }
        set { CurrAnim.currAnim = newValue }
    }
    
    var monModel: MonsterModel!
    
    override func didMoveToView(view: SKView) {
        monModel.body.position = view.frame.center
        monModel.body.lockPoint = view.frame.center
        self.addChild(monModel.body)
        
        MonsterPreviewScene.currAnim = MCAnimation()
        MonsterPreviewScene.currAnim!.comps = [
            MCAnimationComp.rotatePart(.leg, actsOnSide: .both, duration: 0.5, delay: 0, angle: 45)
        ]
        
        doCurrentAnimation(monModel)
    }
    
    func doCurrentAnimation(node: MonsterModel) {
        // Repeat this forever: Run the actions in MCAnimation, then call resetAnimation
        node.doAnimation(MonsterPreviewScene.currAnim!)
        println("running animation on guy")
        
        delay(MonsterPreviewScene.currAnim!.totalDuration) {
            
            node.resetAnimations()
            println("Resetting animation")
            delay(0.2) {
                self.doCurrentAnimation(node)
            }
        }
    }
}