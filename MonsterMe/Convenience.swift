//
//  Convenience.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 1/8/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

// ---------------------------------------------------
//  Convenience.swift defines a bunch of handy
//   extensions, global functions, and constants that
//   make your life easier and your code simpler.
//  
//  ROCK ON
// ---------------------------------------------------

import Foundation
import UIKit

let π: CGFloat = CGFloat(M_PI) // heehee

/**
Random float between min and max (inclusive).

:param: min
:param: max
:returns: Random number

Credit to https://github.com/pNre/ExSwift
*/
func randomFloat(min: CGFloat = 0, max: CGFloat) -> CGFloat {
    let diff = max - min;
    let rand = CGFloat(arc4random() % (UInt32(RAND_MAX) + 1))
    return ((rand / CGFloat(RAND_MAX)) * diff) + min;
}

/** Perform a block of code after a delay.  Neat! */
func delay(delay:Double, closure:()->()) {
    dispatch_after(
        dispatch_time(
            DISPATCH_TIME_NOW,
            Int64(delay * Double(NSEC_PER_SEC))
        ),
        dispatch_get_main_queue(), closure)
}


/** Cool stuff to make CGRects awesomer */
extension CGRect {
    var center: CGPoint {
        get {
            return self.origin + CGPoint(x: width/2, y: height/2)
        }
    }
    
    public func contains(point: CGPoint) -> Bool {
        return CGRectContainsPoint(self, point)
    }
}


// MARK: CGPoint Function Extensions
///// ----------   ADDITION & SUBTRACTION --------- //////

/** POINT + POINT = NEW POINT */
public func + (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x + right.x, y: left.y + right.y)
}
public func += (inout left: CGPoint, right: CGPoint) {
    left = left + right
}

/** POINT - POINT = NEW POINT */
public func - (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x - right.x, y: left.y - right.y)
}
public func -= (inout left: CGPoint, right: CGPoint) {
    left = left - right
}


///// ----------   DIVISION & MULTIPLICATION --------- //////

/** POINT * POINT = NEW POINT */
public func * (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x * right.x, y: left.y * right.y)
}
public func *= (inout left: CGPoint, right: CGPoint) {
    left = left * right
}

/** POINT * CONSTANT = NEW POINT */
public func * (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x * scalar, y: point.y * scalar)
}
public func *= (inout point: CGPoint, scalar: CGFloat) {
    point = point * scalar
}

/** POINT / POINT = NEW POINT */
public func / (left: CGPoint, right: CGPoint) -> CGPoint {
    return CGPoint(x: left.x / right.x, y: left.y / right.y)
}
public func /= (inout left: CGPoint, right: CGPoint) {
    left = left / right
}

/** POINT / CONSTANT = NEW POINT */
public func / (point: CGPoint, scalar: CGFloat) -> CGPoint {
    return CGPoint(x: point.x / scalar, y: point.y / scalar)
}
public func /= (inout point: CGPoint, scalar: CGFloat) {
    point = point / scalar
}


public extension CGPoint {
    // How far are you from me bb
    public func distanceTo(point otherPoint: CGPoint) -> CGFloat {
        return CGFloat(hypotf(Float(self.x - otherPoint.x), Float(self.y - otherPoint.y)))
    }
}

/** EZ conversion from string->float */
extension String {
    var floatValue: Float {
        return (self as NSString).floatValue
    }
}
