//
//  CGFloat+Assimilation.swift
//
//  Created by Elliot Fiske on 11/26/14.
//  Copyright (c) 2014 Monster Create. All rights reserved.
//

import Foundation
import UIKit

// It's silly that you can't multiply a CGFloat and an Int without casting.
// I assume this will be fixed in the future, in the mean time, here take this:
public func * (a: CGFloat, b: Int) -> CGFloat {
    return a * CGFloat(b)
}

public func *= (inout left: CGFloat, right: Int) {
    left = left * right
}

public func + (a: CGFloat, b: Int) -> CGFloat {
    return a + CGFloat(b)
}

public func += (inout left: CGFloat, right: Int) {
    left = left + right
}