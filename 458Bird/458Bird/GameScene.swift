//
//  GameScene.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/8/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    var sprite: SKSpriteNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        sprite = SKSpriteNode(imageNamed:"Spaceship")
        
        size = view.frame.size
        
        sprite.position = view.frame.center
        sprite.physicsBody = SKPhysicsBody(circleOfRadius: 5.0)
        sprite.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        
        sprite.xScale = 0.5
        sprite.yScale = 0.5
        
        let floor = SKShapeNode()
        let path = UIBezierPath(rect: CGRect(origin: CGPointZero, size: CGSize(width: view.frame.width, height: 10))).CGPath
        floor.path = path
        floor.fillColor = UIColor.redColor()
        floor.position = CGPoint(x: 0, y: 50)
        floor.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: view.frame.width, height: 10))
        floor.physicsBody!.affectedByGravity = false
        floor.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
        
        self.addChild(sprite)
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
//        self.addChild(floor)
        
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        sprite!.physicsBody?.velocity = CGVector(dx: 0, dy: 1000)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
