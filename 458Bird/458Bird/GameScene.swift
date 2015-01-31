//
//  GameScene.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/8/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var monster: MCPartBody = MCPartBody()
    
    // BAD.  BAD CODE.  FEEL BAD.
    var arm1: SKSpriteNode!
    var arm2: SKSpriteNode!
    
    var titleLabel: SKLabelNode!
    var nameLabel: SKLabelNode!
    var controller: GameViewController!
    
    private var showingWords = true
    
    /** 
     * Set up the view, spawn the bird and start generating
     *  obstacles to slide o'er the screen
     */
    override func didMoveToView(view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFromRect: view.frame)
        self.physicsBody!.contactTestBitMask = wallCategory // Hits bird, but NOT obstacles.
        
        size = view.frame.size
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = controller.gameModel
        
        initNewGame()
    }
    
    /** Called when a touch begins */
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        controller.handleSceneTap()
    }
    
    /**
     * Instantiate the SKNode for the player + the background.
     */
    func initNewGame() {
        // Endless scrolling background
        let clouds1 = SKSpriteNode(imageNamed: "clouds")
        let clouds2 = SKSpriteNode(imageNamed: "clouds")
        clouds1.zPosition = -15
        clouds2.zPosition = -15
        clouds1.position = CGPoint(x: size.width/2,     y: size.height - clouds1.size.height/2 - 50)
        clouds2.position = CGPoint(x: size.width * 3/2, y: size.height - clouds2.size.height/2 - 50)
        self.addChild(clouds1)
        self.addChild(clouds2)
        
        let hills1 = SKSpriteNode(imageNamed: "hills")
        let hills2 = SKSpriteNode(imageNamed: "hills")
        hills1.position = CGPoint(x: size.width/2,     y: hills1.size.height/2)
        hills2.position = CGPoint(x: size.width * 3/2, y: hills2.size.height/2)
        hills1.zPosition = -15
        hills2.zPosition = -15
        self.addChild(hills1)
        self.addChild(hills2)
        
        let scrollAction = SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.moveByX(-size.width, y: 0, duration: 8),
                SKAction.moveByX(size.width,  y: 0, duration: 0)
                ])
        )
        hills1.runAction(scrollAction)
        hills2.runAction(scrollAction)
        
        let scrollActionSlower = SKAction.repeatActionForever(
            SKAction.sequence([
                SKAction.moveByX(-size.width, y: 0, duration: 16),
                SKAction.moveByX(size.width,  y: 0, duration: 0)
                ])
        )
        clouds1.runAction(scrollActionSlower)
        clouds2.runAction(scrollActionSlower)
        
        // Init player node
        monster.position = frame.center
        monster.physicsBody = SKPhysicsBody(circleOfRadius: 5.0)
        monster.physicsBody!.contactTestBitMask = obstacleCategory | wallCategory
        
        /** TODO: fix this awful code */
        arm1 = SKSpriteNode(imageNamed: "monsterLeg")
        arm2 = SKSpriteNode(imageNamed: "monsterLeg")
        
        arm1.anchorPoint = CGPoint(x: 0.15, y: 0.5)
        arm2.anchorPoint = CGPoint(x: 0.15, y: 0.5)
        
        monster.addChild(arm1)
        monster.addChild(arm2)
        
        self.addChild(monster)
        
        
        
        arm1.position = CGPoint(x:  40, y: 10)
        arm1.xScale = 0.5
        arm1.yScale = 0.5
        arm1.zPosition = -10
        arm2.position = CGPoint(x: -40, y: 10)
        arm2.xScale = -0.5
        arm2.yScale = 0.5
        arm2.zPosition = -10

        getReadyToStart()
    }
    
    /**
     * Snap the user to the center and float them there, ready for the next game
     */
    func getReadyToStart() {
        monster.physicsBody!.affectedByGravity = false
        
        let slideToCenter = SKAction.moveTo(frame.center, duration: 0.5)
        monster.runAction(slideToCenter)
        let resetRotation = SKAction.rotateToAngle(0, duration: 0.5)
        monster.runAction(resetRotation)
    }
    
    /**
     * User is now playing the game! whoo
     */
    func beginGame() {
        monster.physicsBody!.affectedByGravity = true
        spawnObstacle()
    }
    
    /**
     * Make one of the obstacles that floats across the screen
     */
    func spawnObstacle() {
        let obstacleTop = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 40, height: 100))
        obstacleTop.anchorPoint = CGPoint(x: 0, y: 1)
        obstacleTop.position = CGPoint(x: CGRectGetMaxX(frame), y: CGRectGetMaxY(frame))
        obstacleTop.zPosition = 10
        makeObstaclePhysicsBody(obstacleTop)
        
        let obstacleBottom = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 40, height: 200))
        obstacleBottom.anchorPoint = CGPoint(x: 0, y: 0)
        obstacleBottom.position = CGPoint(x: CGRectGetMaxX(frame), y: 0)
        obstacleBottom.zPosition = 10
        makeObstaclePhysicsBody(obstacleBottom)
        
        addChild(obstacleTop)
        addChild(obstacleBottom)
        
        let moveAcrossScreen = SKAction.moveToX(0, duration: 4)
        obstacleTop.runAction(moveAcrossScreen)
        obstacleBottom.runAction(moveAcrossScreen)
    }
    
    /**
     * Give the obstacle its physicsbody - a floating rect that hits the bird
     */
    func makeObstaclePhysicsBody(obstacle: SKNode) {
        obstacle.physicsBody = SKPhysicsBody(edgeLoopFromRect: obstacle.frame)
        obstacle.physicsBody!.affectedByGravity = false
        obstacle.physicsBody!.contactTestBitMask = obstacleCategory
    }
    
    /**
     * FLAP. THAT. BIRD.
     */
    func flap() {
        monster.physicsBody?.velocity = CGVector(dx: 0, dy: 1000)
        
        let rotateAction1 = SKAction.rotateByAngle(-π/3, duration: 0.1)
        let resetAction1  = SKAction.rotateByAngle( π/3, duration: 0.2)
        resetAction1.timingMode = .EaseIn
        
        let rotateAction2 = SKAction.rotateByAngle( π/3, duration: 0.1)
        let resetAction2  = SKAction.rotateByAngle(-π/3, duration: 0.2)
        resetAction2.timingMode = .EaseIn
        
        arm1?.runAction(SKAction.sequence([rotateAction1, resetAction1]))
        arm2?.runAction(SKAction.sequence([rotateAction2, resetAction2]))
    }
    
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
