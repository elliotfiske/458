//
//  AnimatorModel.swift
//  458Bird
//
//  Created by Elliot Fiske on 2/13/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import Foundation
import UIKit

class AnimatorModel: NSObject {
    var previewController: AnimPreviewController
    var monModel: MonsterModel!
    
    init(controller: AnimPreviewController) {
        self.previewController = controller
        
        super.init()
        
        self.monModel = elliotsShame()
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
}