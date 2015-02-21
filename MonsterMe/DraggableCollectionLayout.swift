//
//  DraggableCollectionLayout.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 12/18/14.
//  Copyright (c) 2014 Monster Create. All rights reserved.
//

import Foundation

class DraggableCollectionLayout: UICollectionViewFlowLayout {
    var swoopUp = false
    
    override func prepareLayout() {
        self.itemSize = CGSize(width: 80, height: 80)
        self.minimumLineSpacing = 30
        self.scrollDirection = .Horizontal
        self.sectionInset = UIEdgeInsets(top: 0, left: 30, bottom: 0, right: 30)
    }
    
    
    override func initialLayoutAttributesForAppearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)
        attributes.alpha = 0
        attributes.center.y += (swoopUp ? -1 : 1) * 150
        return attributes
    }
    
    override func finalLayoutAttributesForDisappearingItemAtIndexPath(itemIndexPath: NSIndexPath) -> UICollectionViewLayoutAttributes? {
        let attributes = layoutAttributesForItemAtIndexPath(itemIndexPath)
        attributes.alpha = 0
        attributes.center.y += (swoopUp ? 1 : -1) * 150
        return attributes
    }
    
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        var attributes = super.layoutAttributesForItemAtIndexPath(indexPath)
        if attributes == nil {
            attributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
        }
        
        attributes.alpha = 1
        return attributes
    }
}