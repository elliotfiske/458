//
//  BuilderNavigationBar.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

class BuilderNavigationBar: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.redColor()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}