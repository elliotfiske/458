//
//  MonsterBody.swift
//  MonsterAnim
//
//  Created by Kyle Piddington on 8/5/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

let BASE_CATEGORY: UInt32 = 0x2
let PART_CATEGORY: UInt32 = 0x1

class MCPart: SKSpriteNode {

    var partType: PartType {
        fatalError("Each part subclass has to override this with its part type !")
    }
    
    var stuckOnMonster = false     // Only applicable if limb == true
    var containedInMonster = false // Only applicable if limb == false
    
    /** Gives the mirror of the current part. Note that each mirrored part should have the OTHER one as a mirroredPart */
    var mirroredPart: MCPart? = nil
    var isMirroredPart = false
    
    /** The part's position when it's stuck to the body */
    var lockPoint: CGPoint?
    /** The point where we've last seen the user's finger move to */
    var dragPoint: CGPoint?
    var animateAttachPoint = CGPointZero
    
    /** The user can drag a color onto a monster, then back out.  Save the temporary color
    *   as 'tentative' until they actually drop it on. */
    var tentativeColor: UIColor?
    /** The part needs to remember what color it was before the user tried changing it */
    var savedColor: UIColor
    /** The part needs to remember what texture it was before it was changed (e.g. mouth emotion, eye blink) */
    var savedTexture: SKTexture!
    var textureName: String
    
    /** The user can rotate and scale parts, we want to remember their original parameters */
    var angle: CGFloat = 0
    var savedScale: CGFloat = 1
    
    /** Describes the last point the node was at BEFORE it was parented to something else */
    var lastParentedPoint: CGPoint = CGPoint()
    var minScale: CGFloat = 0.5
    var maxScale: CGFloat = 2
    
    init(textureName: String, color: UIColor, anchor: CGPoint) {
        // TODO: figure out how anchor points should work
        
        savedColor = color
        self.textureName = textureName
        
        savedTexture = SKTexture(imageNamed: textureName)
        
        super.init(texture: savedTexture, color: color, size: savedTexture.size())
        
        self.anchorPoint = anchor
        self.color = color
        size = self.texture!.size()
        colorBlendFactor = 1
    }
    
    /**
     * Sets the contact test bit mask so that contact events are generated when the
     *  part touches the monster body
     */
    func selectForCollision() {
        self.physicsBody!.contactTestBitMask = 2
    }
    
    /**
     * Sets the contact test bit mask so that contact events are NOT generated when the
     *  part touches the monster body
     */
    func deselectForCollision() {
        self.physicsBody!.contactTestBitMask = 1
    }
    
    /**
     * Gray out the part and make it transparent when it's not attached to the body
     */
    func setColorNotColliding() {
        self.color = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.1)
        self.colorBlendFactor = 0.75
    }
    
    /**
     * The part is attached to the monster body, put it back to its normal color.
     */
    func setColorColliding() {
        self.color = self.savedColor
        self.colorBlendFactor = 1.0
    }
    
    /**
     * Rotates this part to face directly AWAY from the specified point.
     */
    func rotateToFaceFromPoint(point: CGPoint) {
        let diff = point - position
        var newAngle = atan2(diff.y, diff.x)
        
        if !isMirroredPart { newAngle += π }
        
        self.runAction(SKAction.rotateToAngle(newAngle, duration: 0.05, shortestUnitArc: true))
        
        angle = newAngle
    }
    
    /** Rotates this part to face directly TOWARD the specified point */
    func rotateToFacePoint(point: CGPoint) {
        let diff = point - position
        var newAngle = atan2(diff.y, diff.x)
        
        if isMirroredPart {newAngle += π}
        
        self.runAction(SKAction.rotateToAngle(newAngle, duration: 0.05, shortestUnitArc: true))
        
        angle = newAngle
    }
    
    /** Animates a part to a specific rotation, without a delay */
    func rotateToAngle(newAngle:CGFloat) {
        angle = newAngle
        self.runAction(SKAction.rotateToAngle(angle, duration: 0.0, shortestUnitArc: true))
    }
    
    /**
     * If the user is dragging a part and it's not on the monster, this method returns true.
     */
    func checkIfShouldUnstick(touchPos : CGPoint, node: SKSpriteNode) -> Bool {
        if (!node.frame.contains(touchPos)) {
            self.stuckOnMonster = false
            self.containedInMonster = false
            return true
        }
        return false
    }
    
    /**
     * If the user is tapping this part, returns true.
     */
    func isSelected(selectionPoint: CGPoint) -> Bool {
        return frame.contains(selectionPoint)
    }
    
    /**
     * Add this node as a child to the specified pNode
     */
    func parentToNode(pNode: SKNode) {
        if let parent = self.parent { // If the node already has a parent, DISOWN IT
            position = lastParentedPoint
            self.removeFromParent()
        }
        
        lastParentedPoint = position
        self.xScale /= pNode.xScale
        self.yScale /= pNode.yScale
        
        let difference = position - pNode.position
        
        lockPoint = CGPoint(x: difference.x/pNode.xScale, y: difference.y/pNode.yScale)
        self.position = lockPoint!
        
        pNode.addChild(self)
    }
    
    /**
     * Called once a frame.  Figure out if our targetPoint should change
     * then move towards it.
     */
    func update() {
        let oldPos = position
        var targetPoint: CGPoint?
        if stuckOnMonster {
            targetPoint = lockPoint
        }
        else {
            targetPoint = dragPoint
            
            // Combine with mirrored part if we're near the center
            if (!isMirroredPart && containedInMonster && dragPoint != nil) {
                if (fabs(dragPoint!.x - self.scene!.frame.width/2) < 30) {
                    mirroredPart?.hide()
                    targetPoint!.x = self.scene!.frame.width/2
                }
                else {
                    mirroredPart?.unhide()
                }
            }
        }
        
        // Calculate where to go: 1/4 of the way to the target point
        if let newPos = targetPoint {
            self.position += (newPos - oldPos) / 4
        }
    }
    
//    func animate(anim: MCAnimationComp, parent:SKNode) {
        // to do, holmes
//    }
    
    /**
     * Gives the position that this node would have if it were parented by pNode
     */
    func pointInNode(pNode: SKNode) -> CGPoint {
        var parentPoint = CGPointZero
        if (parent != nil) {
            parentPoint = parent!.position
        }
        
        let translatedPoint = position + parentPoint - pNode.position
        
        return CGPoint(x: translatedPoint.x / pNode.xScale, y: translatedPoint.y / pNode.yScale)
    }
    
    func hide() {
        runAction(SKAction.hide())
    }
    
    func unhide() {
        runAction(SKAction.unhide())
    }
    
    override func setScale(scale: CGFloat) {
        if(abs(scale) > minScale && abs(scale) < maxScale) {
            super.setScale(abs(scale))
            if (isMirroredPart) {
                xScale = -scale
            }
        }
        savedScale = scale
    }
    
    /**  
     * Reset the part's scale after an aniation
     */
    func resetScale() {
        SKAction.scaleXTo(isMirroredPart ? -savedScale : savedScale,
                           y: savedScale,
                    duration: 0.2 )
    }
    
    func snapToLockPoint() {
        if let target = lockPoint {
            position = target
        }
    }
    
    /** Can this part be colored? */
    func colorable() -> Bool {
        return true
    }
    
    /**
     * We dragged a color onto a part.  Show what the part looks like
     *  as that color!
     */
    func setTentativeColor(newColor: UIColor) {
        tentativeColor = newColor
        color = newColor
        colorBlendFactor = 1.0
    }
    
    /**
     * The user released their finger while dragging a color onto a part.
     *   Commit to that color holmes!
     */
    func confirmColor() {
        color = tentativeColor!
        tentativeColor = nil
    }
    
    /**
     * We dragged a color over a part BUT then backed out :(
     *   Reset the color to what it was before
     */
    func restoreColor() {
        color = savedColor
        tentativeColor = nil
    }
    
    /**
     * Body switching! Swoop the part up while the user switches bodies
     */
    func animateDetatchFromMonster() {
        var newPoint: CGPoint
        var offset: CGFloat = 20.0
        newPoint = CGPoint(x: position.x, y: position.y + offset)
        var newScale = CGPoint(x:savedScale+0.1, y:savedScale+0.1)
        if isMirroredPart{
            newScale.x = -newScale.x
        }
        
        runAction(SKAction.group([SKAction.scaleXTo(newScale.x, duration: 0.2),SKAction.scaleYTo(newScale.y,duration:0.2)]))
        runAction(SKAction.fadeAlphaTo(0.2, duration: 0.2))
        animateAttachPoint = CGPoint(x:lockPoint!.x,y:lockPoint!.y)
        lockPoint = newPoint
    }
    
    /**
     * Reattach the the part to the monster.
     */
    func animateAttachToMonster(base: MCPartBody) {
        if let physWorld = scene?.physicsWorld {
            selectForCollision()
            let startPoint = base.parent!.convertPoint(position, fromNode: parent!)
            let endPoint = base.position
            physWorld.enumerateBodiesAlongRayStart(startPoint, end: endPoint, usingBlock: reattachPart)
            deselectForCollision()
        }
    }
    
    /** Block that actually moves the part to the body */
    func reattachPart(body: SKPhysicsBody!, point: CGPoint, norm: CGVector, terminate: UnsafeMutablePointer<ObjCBool>) {
        if body.categoryBitMask == BASE_CATEGORY {
            self.lockPoint = parent!.convertPoint(point, fromNode: body.node!.parent!)
            terminate.memory = true
        }
    }
    
    /**
     * Convert this part to a dictionary of strings, ready to be NSCoded
     */
    func makeDescDict() -> NSDictionary {
        var dict: [NSString: AnyObject] = [:]
        if (self.partType == PartType.hat) {
            dict["keyInDict"] = PartType.decal.rawValue as NSString
        }
        else {
            dict["keyInDict"] = self.partType.rawValue as NSString
        }

        dict["posX"]     = self.position.x.description
        dict["posY"]     = self.position.y.description
        dict["rotation"] = self.angle.description
        dict["scale"]    = self.savedScale.description
        dict["hidden"]   = self.hidden.description
        
        var components = CGColorGetComponents(self.color.CGColor)
        var alpha = CGColorGetAlpha(self.color.CGColor)
        
        dict["colorR"] = components[0].description
        dict["colorG"] = components[1].description
        dict["colorB"] = components[2].description
        dict["colorA"] = alpha.description
        dict["isMirrored"] = (isMirroredPart).description
        println("Dictionary count value is : \(dict.count)")
        if let mir = mirroredPart{
            if(mir.isMirroredPart){
                dict["mirror"] = mir.makeDescDict()
            }
        }
        return dict
    }
    
    /** Restore this part from a dictionary of strings */
    func initWithDict(dict:NSDictionary){
        let posX  = dict["posX"] as String
        let posY  = dict["posY"] as String
        let rot   = dict["rotation"] as String
        let scl   = dict["scale"] as String
        let mir   = dict["isMirrored"] as String
        let hid   = dict["hidden"] as String
        let r     = dict["colorR"] as String
        let g     = dict["colorG"] as String
        let b     = dict["colorB"] as String
        let a     = dict["colorA"] as String
        
        let vals:[CGFloat] = [posX,posY,rot,scl,r,g,b,a].map{
            CGFloat(($0 as NSString).doubleValue)
        }
        
        self.dragPoint = CGPoint(x: vals[0],y:vals[1])
        self.lockPoint = CGPoint(x: vals[0],y:vals[1])
        self.position = CGPoint(x: vals[0],y:vals[1])
        
        if((mir as NSString).boolValue){
            isMirroredPart = true
        }
        else {
            isMirroredPart = false
        }
        
        rotateToAngle(vals[2])
        angle = vals[2]
        
        setScale(vals[3])
        
        if((hid as NSString).boolValue){
            hide()
        }
        
        if (self.colorable()) {
            setTentativeColor(UIColor(red:vals[4],green:vals[5],blue:vals[6],alpha:vals[7]))
            confirmColor()
        }
        else {
            setTentativeColor(UIColor(red:1.0,green:1.0,blue:1.0,alpha:1.0))
            confirmColor()
        }
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
