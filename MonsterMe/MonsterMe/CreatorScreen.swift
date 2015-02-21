//
//  CreatorScreen.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

enum CreatorScreen: Int {
    case body = 0, traits, voice, name, maxScreen
    
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
    
    func initView() -> MCDismissableView {
        switch self {
        case body:
            return BuilderPartView()
        case traits:
            return BuilderPartView()
        case voice:
            return BuilderPartView()
        case name:
            return BuilderPartView()
        case maxScreen:
            println("Hey don't try to init a maxScreen!  that's just there to tell you when we're done.")
            return BuilderPartView()
        }
    }
}