//
//  BuilderPartView.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

class BuilderPartView: MCDismissableView {
    var collectionView: BuilderPartCollectionView!
    
    override init(frame: CGRect) {
        collectionView = BuilderPartCollectionView(frame: frame)
        
        super.init(frame: frame)
        backgroundColor = UIColor.blueColor()
    }
}