//
//  GameScene.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/8/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import SpriteKit
import AVFoundation

class GameScene: SKScene {
    
    var monster: SKSpriteNode!
    var monster2: SKSpriteNode!
    var monster3: SKSpriteNode!
    
    var flapSound = NSURL(fileURLWithPath: NSBundle.mainBundle().pathForResource("flap", ofType: "wav")!)
    var audioPlayer: AVAudioPlayer!
    
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
        self.physicsBody!.collisionBitMask = wallCategory
        self.physicsBody!.categoryBitMask = wallCategory
        self.physicsBody!.dynamic = true
        view.backgroundColor = UIColor.greenColor()
        
        size = view.frame.size
        physicsWorld.gravity = CGVector(dx: 0, dy: -9.8)
        physicsWorld.contactDelegate = controller.gameModel
        
        initNewGame()
        
        audioPlayer = AVAudioPlayer(contentsOfURL: flapSound, error: nil)
        audioPlayer.prepareToPlay()
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
//        self.addChild(clouds1)
//        self.addChild(clouds2)
        
        let hills1 = SKSpriteNode(imageNamed: "hills")
        let hills2 = SKSpriteNode(imageNamed: "hills")
        hills1.position = CGPoint(x: size.width/2,     y: hills1.size.height/2)
        hills2.position = CGPoint(x: size.width * 3/2, y: hills2.size.height/2)
        hills1.zPosition = -15
        hills2.zPosition = -15
//        self.addChild(hills1)
//        self.addChild(hills2)
        
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
        monster.xScale = 0.5
        monster.yScale = 0.5
        monster.physicsBody = SKPhysicsBody(circleOfRadius: 5.0)
        monster.physicsBody!.contactTestBitMask = obstacleCategory | wallCategory
        monster.physicsBody!.collisionBitMask = obstacleCategory | wallCategory
        monster.physicsBody!.categoryBitMask = obstacleCategory | wallCategory
        monster.physicsBody!.mass = 0.00001
        
        self.addChild(monster)
        
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
        monster.physicsBody!.affectedByGravity = false
        wander()
    }
    
    func wander() {
        let action = SKAction.runBlock() {
            let randomVec = CGVector(dx: randomFloat(min: -20, 20), dy: randomFloat(min: -20, 20))
            self.monster.runAction(SKAction.moveBy(randomVec, duration: 0.2))
        }
        let repeat = SKAction.repeatActionForever(SKAction.sequence([action, SKAction.waitForDuration(2, withRange: 1)]))

        
        let action2 = SKAction.runBlock() {
            let randomVec = CGVector(dx: randomFloat(min: -20, 20), dy: randomFloat(min: -20, 20))
            self.monster2.runAction(SKAction.moveBy(randomVec, duration: 0.2))
        }
        let repeat2 = SKAction.repeatActionForever(SKAction.sequence([action2, SKAction.waitForDuration(2, withRange: 1)]))
        
        
        let action3 = SKAction.runBlock() {
            let randomVec = CGVector(dx: randomFloat(min: -20, 20), dy: randomFloat(min: -20, 20))
            self.monster3.runAction(SKAction.moveBy(randomVec, duration: 0.2))
        }
        let repeat3 = SKAction.repeatActionForever(SKAction.sequence([action3, SKAction.waitForDuration(2, withRange: 1)]))
        
        
        monster.runAction(repeat)
        monster2.runAction(repeat2)
        monster3.runAction(repeat3)
    }
    
    /**
     * Make one of the obstacles that floats across the screen
     */
    func spawnObstacle() {
        return
        
        let offset: CGFloat = CGFloat(randomFloat(min: -200, 200))
        let obstacleTop = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 40, height: 450))
        obstacleTop.position = CGPoint(x: CGRectGetMaxX(frame), y: CGRectGetMaxY(frame) + offset)
        obstacleTop.zPosition = 10
        obstacleTop.texture = SKTexture(imageNamed: "cactus")
        makeObstaclePhysicsBody(obstacleTop)
        
        let obstacleBottom = SKSpriteNode(color: UIColor.redColor(), size: CGSize(width: 40, height: 450))
        obstacleBottom.position = CGPoint(x: CGRectGetMaxX(frame), y: offset)
        obstacleBottom.zPosition = 10
        obstacleBottom.texture = SKTexture(imageNamed: "cactus")
        makeObstaclePhysicsBody(obstacleBottom)
        
        addChild(obstacleTop)
        addChild(obstacleBottom)
        
        let moveAcrossScreen = SKAction.moveToX(-40, duration: 4)
        obstacleTop.runAction(SKAction.sequence([moveAcrossScreen, SKAction.removeFromParent()]))
        obstacleBottom.runAction(SKAction.sequence([moveAcrossScreen, SKAction.removeFromParent()]))
    }
    
    /**
     * Give the obstacle its physicsbody - a floating rect that hits the bird
     */
    func makeObstaclePhysicsBody(obstacle: SKNode) {
        obstacle.physicsBody = SKPhysicsBody(rectangleOfSize: CGSize(width: 40, height: 450))
        obstacle.physicsBody!.affectedByGravity = false
        obstacle.physicsBody!.contactTestBitMask = obstacleCategory
        obstacle.physicsBody!.collisionBitMask = obstacleCategory
        obstacle.physicsBody!.categoryBitMask = obstacleCategory
        obstacle.physicsBody!.mass = 1000000
    }
    
    /**
     * FLAP. THAT. BIRD.
     */
    func flap() {
//        monster.physicsBody?.velocity = CGVector(dx: 0, dy: 800)
//        audioPlayer.play()
    }
    
    override func update(currentTime: CFTimeInterval) {
        controller.handleUpdate(currentTime)
    }
    
    
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
