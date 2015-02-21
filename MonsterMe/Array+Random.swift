//
//  Array+Random.swift
//  MonsterAnim
//
//  Created by Elliot Fiske on 1/23/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

extension Array {
    func randomItem() -> T {
        let index = Int(arc4random_uniform(UInt32(self.count)))
        return self[index]
    }
}