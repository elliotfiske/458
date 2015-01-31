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
     * User hit the wall or an obstacle.  Game over man, game over!
     */
    func didBeginContact(contact: SKPhysicsContact) {
        if currState == .running {
            gameController.showGameOver(0)
            currState = .gameOver
        }
    }
    
    func didEndContact(contact: SKPhysicsContact) {
        // Stopped hitting something!
    }
}
