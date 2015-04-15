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
        var currView = self.view as! MonsterPreviewSKView
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
    var monModel: MonsterModel!
    var currAnimation: Animation!
    
    override func didMoveToView(view: SKView) {
        monModel.body.position = view.frame.center
        monModel.body.lockPoint = view.frame.center
        self.addChild(monModel.body)
        
        doCurrentAnimation(monModel)
    }
    
    func doCurrentAnimation(model: MonsterModel) {
        // Repeat this forever: Run the actions in MCAnimation, then call resetAnimation
        model.doAnimation(currAnimation)
        println("running animation on guy")
        
        delay(currAnimation.totalDuration) {
            model.resetAnimations()
            println("Resetting animation")
            delay(0.2) {
                [unowned self] in
                self.doCurrentAnimation(model)
            }
        }
    }
}