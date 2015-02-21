//
//  PlanetSceneController.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//
//
//   Welcome to the planet scene controller!
//
//   This is essentially the "root" view controller that every child view controller and scene
//    will be parented to, if you go back far enough.
//
//   It maintains references to the Planet Model, which handles the current monster and props
//    on the actual Planet Scene.
//
//   It handles all the user touch events to the planet scene, passing them to their appropriate
//    model for processing.

import UIKit
import SpriteKit


class PlanetSceneController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let scene = PlanetScene.unarchiveFromFile("PlanetScene") as? PlanetScene {
            // Configure the view.
            let skView = self.view as SKView
            skView.showsFPS = true
            skView.showsNodeCount = true
            
            /* We don't care how siblings order themselves.  Helps boost performance */
            skView.ignoresSiblingOrder = true
            
            /* Set the scale mode to scale to fit the window */
            scene.scaleMode = .AspectFill
            
            skView.presentScene(scene)
        }
    }

    override func shouldAutorotate() -> Bool {
        return true
    }

    /** Set up autorotation */
    override func supportedInterfaceOrientations() -> Int {
        if UIDevice.currentDevice().userInterfaceIdiom == .Phone {
            return Int(UIInterfaceOrientationMask.AllButUpsideDown.rawValue)
        } else {
            return Int(UIInterfaceOrientationMask.All.rawValue)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}



//// This is just a pre-built extension that lets us use the .sks, basically Sprite Kit's
////  equivalent of a storyboard.  We don't use it for anything other than
////  initial setup of the game scene though.
extension SKNode {
    class func unarchiveFromFile(file : NSString) -> SKNode? {
        if let path = NSBundle.mainBundle().pathForResource(file, ofType: "sks") {
            var sceneData = NSData(contentsOfFile: path, options: .DataReadingMappedIfSafe, error: nil)!
            var archiver = NSKeyedUnarchiver(forReadingWithData: sceneData)
            
            archiver.setClass(self.classForKeyedUnarchiver(), forClassName: "SKScene")
            let scene = archiver.decodeObjectForKey(NSKeyedArchiveRootObjectKey) as PlanetScene
            archiver.finishDecoding()
            return scene
        } else {
            return nil
        }
    }
}