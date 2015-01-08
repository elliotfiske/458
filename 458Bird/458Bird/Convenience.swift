//
//  Convenience.swift
//  FourFiftyEightBird
//
//  Created by Elliot Fiske on 1/8/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

// BOY HOWDY THIS SOME HANDY STUFF HUH

import Foundation
import UIKit

let π: CGFloat = CGFloat(M_PI) // heehee

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

import Foundation
import CoreGraphics

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