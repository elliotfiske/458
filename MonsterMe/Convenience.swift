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



/**** Instantiate UIColor from hex string */
extension UIColor {
    convenience init(red: UInt32, green: UInt32, blue: UInt32) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(hexString: String) {
        let scanner = NSScanner(string: hexString)
        var netHex: UInt32 = 0
        scanner.scanHexInt(&netHex)
        
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
}


/**
 * Given any UIView, modifies it in-place to be round instead of square.
 */
func roundView(view: UIView, toDiameter diameter: CGFloat) {
    let saveCenter: CGPoint = view.center
    let newFrame: CGRect = CGRectMake(view.frame.origin.x, view.frame.origin.y, diameter, diameter)
    view.frame = newFrame
    view.layer.cornerRadius = diameter / 2
    view.center = saveCenter
}


// TODO: split up these "handy" functions this files gettin kinda big
func bonvenoFont(size: CGFloat) -> UIFont {
    return UIFont(name: "BonvenoCF-Light", size: size)!
}
func leagueFont(size: CGFloat) -> UIFont {
    return UIFont(name: "League Gothic", size: size)!
}