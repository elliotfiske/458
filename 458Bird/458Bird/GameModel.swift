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
    
    init(controller: GameViewController) {
        gameController = controller
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
