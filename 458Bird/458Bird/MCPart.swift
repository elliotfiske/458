//
//  MonsterBody.swift
//  MonsterAnim
//
//  Created by Kyle Piddington on 8/5/14.
//  Copyright (c) 2014 Kyle Piddington. All rights reserved.
//

import Foundation
import SpriteKit

private var myContext = 0

/** An enum that keeps track of every kind a body part can be.
 *   Also has a few helper methods that categorize the different aspects of parts.
 *   'Color' is a part type since it's implemented as a MCBodyPart
 */
enum PartType: String {
    case arm = "arm"
    case leg = "leg"
    case body = "body"
    case eye = "eye"
    case eyeEmotion = "eyeEmotion"
    case decal = "decal"
    case mouth = "mouth"
    case base = "base"
    case hat = "hat"
    case legBase = "legBase"
    case color = "color"
    
    /** Determines if this part will be colored the same as the body by default. */
    func matchesBodyColor() -> Bool {
        switch(self) {
        case body, arm, leg:
            return true
        default:
            return false
        }
    }
    
    func displayName() -> String {
        switch (self) {
        case .arm:
            return "arms"
        case .leg:
            return "legs"
        case .mouth:
            return "mouths"
        case .decal:
            return "stuff"
        case .eye:
            return "eyes"
        default:
            return self.rawValue
        }
    }
}


class MCPart: SKSpriteNode {
    /** The user can drag a color onto a monster, then back out.  Save the temporary color
     *   as 'tentative' until they actually drop it on. */
    var tentativeColor: UIColor?
    /** The part needs to remember what color it was before the user tried changing it */
    var savedColor: UIColor
    
    /** Limbs act differently than decals/mouths, in that they stick to the OUTSIDE of the monster
     *   instead of being directly on the monster body. */
    var limb: Bool {
        get {
            return partType == .arm || partType == .leg
        }
    }
    
    var scale:CGFloat = 1.0
    var partType: PartType
    var stuckOnMonster = false     // Only applicable if limb == true
    var containedInMonster = false // Only applicable if limb == false
    
    /** TRUE if this is the part we're dragging, FALSE if it's a mirrored part */
    var selected = true
    /** Gives the mirror of the current part. Note that each mirrored part should have the OTHER one as a mirroredPart */
    var mirroredPart: MCPart? = nil
    
    /** The part's position when it's stuck to the body */
    var lockPoint: CGPoint?
    /** The point where we've last seen the user's finger move to */
    var dragPoint: CGPoint?
    
    /** The user can rotate parts, we want to remember how much they rotated them by */
    var angle: CGFloat = 0
    
    var lastParentedPoint: CGPoint = CGPoint() // TODO: Is this the same as lockPoint?  Can it be the same as lockPoint??
    var minScale: CGFloat = 0.5
    var maxScale: CGFloat = 2
    
    init(textureName: String, color: UIColor) {
        self.texture = SKTexture(imageNamed: textureName)
        self.size = self.texture!.size()
        self.color = color
        self.savedColor = color
        
        super.init()
        
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
        
        if selected { newAngle += π }
        
        self.runAction(SKAction.rotateToAngle(newAngle, duration: 0.05, shortestUnitArc: true))
        
        angle = newAngle
    }
    
    /** Rotates this part to face directly TOWARD the specified point */
    func rotateToFacePoint(point: CGPoint) {
        let diff = point - position
        var newAngle = atan2(diff.y, diff.x)
        
        if !selected {newAngle += π}
        
        self.runAction(SKAction.rotateToAngle(newAngle, duration: 0.05, shortestUnitArc: true))
        
        angle = newAngle
    }
    
    /** Animates a part to a specific rotation, without a delay */
    func rotateToAngle(newAngle:CGFloat){
        angle = newAngle
        self.runAction(SKAction.rotateToAngle(angle, duration: 0.0, shortestUnitArc: true))
    }
    
    func checkIfShouldUnstick(touchPos : CGPoint, node: SKSpriteNode) -> Bool {
        if (!node.frame.contains(touchPos)) {
            self.stuckOnMonster = false
            self.containedInMonster = false
            return true
        }
        return false
    }
    
    func isSelected(selectionPoint: CGPoint) -> Bool {
        return node.frame.contains(selectionPoint)
    }
    
    func parentToNode(pNode: SKNode) {
        if let parent = self.node.parent {
            //self.node.xScale *= fabs(parentedScale.x)
            //self.node.yScale *= fabs(parentedScale.y)
            node.position = lastParentedPoint
            self.node.removeFromParent()
        }
        lastParentedPoint = node.position
        self.node.xScale = node.xScale/pNode.xScale
        self.node.yScale = node.yScale/pNode.yScale
        parentedScale = CGPoint(x: pNode.xScale/node.xScale, y: pNode.yScale/node.yScale)
        
        //Replace this with an Affine Transformation???
        
        lockPoint = CGPoint(x: (node.position.x-pNode.position.x)/pNode.xScale, y: (node.position.y-pNode.position.y)/pNode.yScale)
        node.position = lockPoint!
        
        pNode.addChild(node)
    }
    
    /**
    * Called once a frame.  Figure out if our targetPoint should change
    * then move towards it.
    */
    func update() {
        let oldPos = node.position
        var targetPoint: CGPoint?
        if stuckOnMonster {
            targetPoint = lockPoint
        }
        else {
            targetPoint = dragPoint
            
            // Combine with mirrored part if we're near the center
            if (selected && containedInMonster && dragPoint != nil) {
                if (fabs(dragPoint!.x - node.scene!.frame.width/2) < 30) {
                    mirroredPart?.hide()
                    targetPoint!.x = node.scene!.frame.width/2
                }
                else {
                    mirroredPart?.unHide()
                }
            }
        }
        
        // Calculate where to go: 1/4 of the way to the target point
        if let newPos = targetPoint {
            node.position += (newPos - oldPos) / 4
        }
    }
    
//    func animate(anim: MonsterAnimation, parent:SKNode) {
        // to do, holmes
//    }
    
    func moveToLockPoint() {
        if (stuckOnMonster && lockPoint != nil) {
            self.node.position = lockPoint!
        }
    }
    
    func setPosition(point:CGPoint) {
        self.dragPoint = point
    }
    
    func setMirror(part:MCPart) {
        mirroredPart = part
        part.mirroredPart = self
    }
    
    func getSelectedAndMirrored() -> (MCPart?, MCPart?) {
        if let pt = mirroredPart {
            return (self,pt)
        }
        return (self,nil)
    }
    
    func pointInNode(pNode: SKNode) -> CGPoint {
        let xScale = node.xScale/pNode.xScale
        let yScale = node.yScale/pNode.yScale
        var parentPoint = CGPoint()
        if (node.parent != nil) {
            parentPoint = node.parent!.position
        }
        
        let translatedPoint = node.position + parentPoint - pNode.position
        return CGPoint(x: translatedPoint.x / pNode.xScale, y: translatedPoint.y / pNode.yScale)
    }
    
    func hide() {
        if (!hidden) {
            hidden = true
            node.runAction(SKAction.hide())
        }
    }
    
    func unHide() {
        if (hidden) {
            hidden = false
            node.runAction(SKAction.unhide())
        }
    }
    
    func setScale(scale: CGFloat) {
        if(abs(scale) > minScale && abs(scale) < maxScale) {
            node.setScale(abs(scale))
            self.scale=scale
            if (!selected) {
                node.xScale = -abs(scale)
            }
        }
    }
    
    /**
     * We dragged a color onto a part.  Show what the part looks like
     *  as that color!
     */
    func setTentativeColor(newColor: UIColor) {
        tentativeColor = newColor
        node.color = newColor
        node.colorBlendFactor = 1.0
    }
    
    /**
     * The user released their finger while dragging a color onto a part.
     *   Commit to that color holmes!
     */
    func confirmColor() {
        partColor = tentativeColor!
        tentativeColor = nil
    }
    
    /**
     * We dragged a color over a part BUT then backed out :(
     *   Reset the color to what it was before
     */
    func restoreColor() {
        node.color = partColor
        tentativeColor = nil
    }
    
    func animateDetatchFromMonster(){
        var newPoint:CGPoint
        var direction:CGVector = CGVector(dx:node.position.x, dy:node.position.y)
        direction = normScale(direction,to:100.0)
        newPoint = CGPoint(x: node.position.x + direction.dx, y: node.position.y + direction.dy)
        lockPoint = newPoint
        
    }
    func animateAttachToMonster(base:MCPartBody){
        
        if let physWorld = node.scene?.physicsWorld
        {
            
            selectForCollision()
//            physWorld.enumerateBodiesAlongRayStart(base.node.parent!.convertPoint(node.position, fromNode:node.parent!), end: base.node.position, usingBlock: castRayToCenter)
            deselectForCollision()
        }
    }
    func normScale(vecIn: CGVector, to:CGFloat) -> CGVector{
        if(vecIn.dx == 0 && vecIn.dy == 0){
            return CGVector.zeroVector
        }
        let length = sqrtf(Float(vecIn.dx * vecIn.dx) + Float(vecIn.dy * vecIn.dy))
        let scaleFactor = to/CGFloat(length)
        return CGVector(dx:vecIn.dx*scaleFactor,dy:vecIn.dy*scaleFactor)
    }
    func castRayToCenter(body: SKPhysicsBody!, point: CGPoint, norm: CGVector, terminate: UnsafeMutablePointer<ObjCBool>){
        let baseCategory:UInt32 = 0x2
        if body.categoryBitMask == baseCategory{
            self.lockPoint=node.parent!.convertPoint(point,fromNode:body.node!.parent!)
            terminate.memory = true
        }
    }
    func makeDescDict() -> NSDictionary
    {
        var dict: [NSString: AnyObject] = [:]
        if(self.partType == PartType.hat){
            dict["keyInDict"] = PartType.decal.rawValue as NSString
        }
        else{
            dict["keyInDict"] = self.partType.rawValue as NSString
        }
        dict["indexInDict"] = index.description
        dict["posX"] = self.node.position.x.description
        dict["posY"] = self.node.position.y.description
        dict["rotation"] = self.angle.description
        dict["scale"] = self.scale.description
        dict["hidden"] = self.hidden.description
        var components = CGColorGetComponents(self.node.color.CGColor)
        var alpha = CGColorGetAlpha(self.node.color.CGColor)
        
        dict["colorR"] = components[0].description
        dict["colorG"] = components[1].description
        dict["colorB"] = components[2].description
        dict["colorA"] = alpha.description
        dict["isMirrored"] = (!selected).description
        println("Dictionary count value is : \(dict.count)")
        if let mir = mirroredPart{
            if(!mir.selected){
                dict["mirror"] = mir.makeDescDict()
            }
        }
        return dict
    }
    func initWithDict(dict:NSDictionary){
        let posX  = dict["posX"] as String
        let posY  = dict["posY"] as String
        let rot  = dict["rotation"] as String
        let scl  = dict["scale"] as String
        let mir = dict["isMirrored"] as String
        let hid = dict["hidden"] as String
        let r  = dict["colorR"] as String
        let g  = dict["colorG"] as String
        let b  = dict["colorB"] as String
        let a  = dict["colorA"] as String
        
        let vals:[CGFloat] = [posX,posY,rot,scl,r,g,b,a].map{
            CGFloat(($0 as NSString).doubleValue)
        }
        self.setPosition(CGPoint(x: vals[0],y:vals[1]))
        self.lockPoint = CGPoint(x: vals[0],y:vals[1])
        self.node.position = CGPoint(x: vals[0],y:vals[1])
        
        
        if((mir as NSString).boolValue){
            selected=false
        }
        else{
            selected=true
        }
        
        rotateToAngle(vals[2])
        angle = vals[2]
        
        setScale(vals[3])
        
        if((hid as NSString).boolValue){
            hide()
        }
        
        if(self.partTemplate.colorable()){
            setTentativeColor(UIColor(red:vals[4],green:vals[5],blue:vals[6],alpha:vals[7]))
            confirmColor()
        }
        else{
            setTentativeColor(UIColor(red:1.0,green:1.0,blue:1.0,alpha:1.0))
            confirmColor();
        }
        
    }
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
