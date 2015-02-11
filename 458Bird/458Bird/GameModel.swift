//
//  GameModel.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/15/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import UIKit
import SpriteKit

enum GameState {
    case start, gameOver, paused, running
}

let wallCategory: UInt32 = 0x1
let obstacleCategory: UInt32 = 0x2

class GameModel: NSObject, SKPhysicsContactDelegate {
    private var currState = GameState.start
    private var gameController: GameViewController!
    
    private var obstacleSpawnTime: CFTimeInterval = 0
    private var lastSpawnTime: CFTimeInterval = 0
    
    var monModel: MonsterModel!
    
    init(controller: GameViewController) {
        gameController = controller
        
        super.init()

        let model1 = elliotsShame()
        let model2 = elliotsShame()
        let model3 = elliotsShame()
        
        
        gameController.setMainMonster(model1.body)
        gameController.setMon2(model2.body)
        gameController.setMon3(model3.body)
    }
    
    func elliotsShame() -> MonsterModel {
        /** ALL THIS IS SECRET AWFUL CODE THAT ELLIOT IS ASHAMED OF */
        let monsterBody = MCPartBody(imageNamed: "monsterBody")
        monModel = MonsterModel(newBody: monsterBody, bodyColor: UIColor.redColor())
        
        let eye1 = MCPartEye(textureName: "eye1", color: UIColor.whiteColor(), anchor: CGPoint(x: 0.5, y: 0.5), pupilTextureName: "pupil1")
        eye1.position = CGPoint(x: -47.419, y: 34.541)
        eye1.setScale(0.25)
        let eye2 = MCPartEye(textureName: "eye1", color: UIColor.whiteColor(), anchor: CGPoint(x: 0.5, y: 0.5), pupilTextureName: "pupil1")
        eye2.isMirroredPart = true
        eye2.position = CGPoint(x: 47.419, y: 34.541)
        eye2.setScale(0.25)
        
        let mouth = MCPartMouth(textureName: "mouth1", color: UIColor.whiteColor(), anchor: CGPoint(x: 0.5, y: 0.5))
        mouth.position = CGPoint(x: 0, y: -57.10)
        
        
        let arm1 = MCPartArm(textureName: "arm1", color: UIColor.whiteColor(), anchor: CGPoint(x: 0.15, y: 0.85))
        arm1.position = CGPoint(x: 55.54, y: -127.35)
        arm1.setScale(1)
        arm1.rotateToAngle(π/2 + 0.1)
        
        let arm2 = MCPartArm(textureName: "arm1", color: UIColor.whiteColor(), anchor: CGPoint(x: 0.15, y: 0.85))
        arm2.isMirroredPart = true
        arm2.position = CGPoint(x: -55.54, y: -127.35)
        arm2.setScale(1)
        arm2.rotateToAngle(-π/2 - 0.1)
        
        let leg1 = MCPartLeg(textureName: "leg1", color: UIColor.whiteColor(), anchor: CGPoint(x: 0.05, y: 0.5), baseAnchor: CGPoint(x: 0.95, y: 0.5))
        leg1.position = CGPoint(x: 88.126, y: 1.978)
        leg1.setScale(1)
        leg1.rotateToAngle(0)
        
        let leg2 = MCPartLeg(textureName: "leg1", color: UIColor.whiteColor(), anchor: CGPoint(x: 0.05, y: 0.5), baseAnchor: CGPoint(x: 0.95, y: 0.5))
        leg2.isMirroredPart = true
        leg2.position = CGPoint(x: -88.126, y: 1.978)
        leg2.setScale(1)
        leg2.rotateToAngle(0)
        
        let hat = MCPartHat(textureName: "fezHat", color: UIColor.whiteColor(), anchor: CGPoint(x: 0.5, y: 1))
        hat.position = CGPoint(x: 0, y: 151.91)
        hat.setScale(0.4)
        
        
        monModel.addPart(eye1)
        monModel.addPart(eye2)
        
        monModel.addPart(mouth)
        
        monModel.addPart(arm1)
        monModel.addPart(arm2)
        
        monModel.addPart(leg1)
        monModel.addPart(leg2)
        
        monModel.addPart(hat)
        /** END SECRET AWFUL CODE */
        
        return monModel
    }
    
    func handleTap(sender: UIGestureRecognizer) {
        switch (currState) {
        case .start, .paused:
            gameController.fadeTitleView()
            currState = .running
        case .gameOver:
            gameController.resetGame()
            currState = .start
        default:
            println("Uh oh! Title view is getting in the way of your touch events.")
        }
    }
    
    func handleSceneTap() {
        if currState == .running {
            gameController.flap()
            

            // SAVED THIS HERE ANIMATION BRAH
            
//            let rotateAction1 = SKAction.rotateByAngle(-π/3, duration: 0.1)
//            let resetAction1  = SKAction.rotateByAngle( π/3, duration: 0.2)
//            resetAction1.timingMode = .EaseIn
//            
//            let rotateAction2 = SKAction.rotateByAngle( π/3, duration: 0.1)
//            let resetAction2  = SKAction.rotateByAngle(-π/3, duration: 0.2)
//            resetAction2.timingMode = .EaseIn
//            
//            arm1?.runAction(SKAction.sequence([rotateAction1, resetAction1]))
//            arm2?.runAction(SKAction.sequence([rotateAction2, resetAction2]))
//            
        }
    }
    
    /**
     * Update the game!  Spawn an obstacle if it's been long enough.
     */
    func handleUpdate(currentTime: CFTimeInterval) {
        if currState != .running {
            return
        }
        
        let diff = currentTime - lastSpawnTime
        if diff > obstacleSpawnTime {
            gameController.spawnObstacle()
            obstacleSpawnTime = CFTimeInterval(randomFloat(min: 1, 3))
            lastSpawnTime = currentTime
        }
    }
    
    /**
     * User hit the wall or an obstacle.  Game over man, game over!
     */
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.contactTestBitMask & contact.bodyB.contactTestBitMask == 0 {
            return
        }
        
        if currState == .running {
            gameController.showGameOver(0)
            currState = .gameOver
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        // Stopped hitting something!
    }
    
}
