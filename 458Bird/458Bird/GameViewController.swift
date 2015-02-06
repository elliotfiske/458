//
//  GameViewController.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/8/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import UIKit
import SpriteKit

extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as GameScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}




class GameViewController: UIViewController {
    /** MVC == Massive View Controller right?? */
    internal var gameModel: GameModel!
    
    /** The view that shows the title until the user taps it */
    private var titleView: FlapTitleView!
    
    var gameScene: GameScene!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = GameScene.unarchiveFromFile("GameScene") as? GameScene {
            gameModel = GameModel(controller: self)
            gameScene = scene
            gameScene.controller = self
            
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            skView.showsPhysics = true
            
            skView.ignoresSiblingOrder = true
            skView.backgroundColor = UIColor(red: 61, green: 197, blue: 238, alpha: 1)
            scene.scaleMode = .ResizeFill
            
            skView.presentScene(scene)
            
            titleView = FlapTitleView(frame: self.view.frame)
            titleView.showTitle()
            let tapper = UITapGestureRecognizer(target: gameModel, action: "handleTap:")
            titleView.addGestureRecognizer(tapper)
            self.view.addSubview(titleView)
        }
    }
    
    /**
     * Fade away the intro screen and start the game!
     */
    func fadeTitleView() {
        titleView.userInteractionEnabled = false
        UIView.animateWithDuration(0.5, animations: {
            [unowned self] in
            self.titleView.alpha = 0
            }, completion: {
                [unowned self]
                (Bool) in
                self.gameScene.beginGame()
            })
    }
    
    /**
     * User done goofed. Show their score, stop the game.
     */
    func showGameOver(score: Int) {
        titleView.showGameOver(score)
        UIView.animateWithDuration(0.5, animations: {
            [unowned self] in
            self.titleView.alpha = 1
            }, completion: {
                [unowned self]
                (Bool) in
                self.titleView.userInteractionEnabled = true
        })
    }
    
    /**
     * Prep for a new game
     */
    func resetGame() {
        titleView.showTitle()
        gameScene.getReadyToStart()
    }
    
    /**
     * User tapped the game scene.  Ask the model what to do.
     */
    func handleSceneTap() {
        gameModel.handleSceneTap()
    }
    
    /**
     * Ask the model how to update the scene.
     */
    func handleUpdate(currentTime: CFTimeInterval) {
        gameModel.handleUpdate(currentTime)
    }
    
    /**
     * Bounce dat bird
     */
    func flap() {
        gameScene.flap()
    }
    
    /**
     * Spawn an obstacle
     */
    func spawnObstacle() {
        gameScene.spawnObstacle()
    }
    

    override func shouldAutorotate() -> Bool {
        return true
    }

    override func supportedInterfaceOrientations() -> Int {
        return Int(UIInterfaceOrientationMask.Landscape.rawValue)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
