//
//  BuilderPartCollectionView.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

class BuilderPartCollectionView: DraggableCollectionView {
    
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        return MCPartCollectionViewCell(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
    }
    
    
    
    
    
    
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}