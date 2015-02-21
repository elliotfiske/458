//
//  CreatorView.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

enum CreatorScreen: Int {
    case body = 0, traits = 1, voice = 2, name = 3, maxScreen = 4
    
    /**
     * What this creator screen's menu bar title is
     */
    func displayName() -> String {
        switch self {
        case body:
            return "BODY"
        case traits:
            return "TRAITS"
        case voice:
            return "VOICE"
        case name:
            return "NAME"
        case maxScreen:
            println("Don't do that! maxScreen isn't a real screen")
            return "ERROR YO"
        }
    }
}