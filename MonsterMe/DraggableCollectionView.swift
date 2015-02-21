//
//  DraggableCollectionView.swift
//  MonsterMe
//
//  Created by Elliot Fiske on 2/20/15.
//  Copyright (c) 2015 Monster Create. All rights reserved.
//

import Foundation

class DraggableCollectionView: UIView,
                               UIGestureRecognizerDelegate,
                               UICollectionViewDataSource,
                               UICollectionViewDelegate {
    
    var collectionView: UICollectionView
    
    /**** BEGIN UICollectionViewDataSource stuff
     *
     *     First, the things that you don't necessarily have to override.
     */
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    /**
     * This has to be overriden, since we don't have any idea what a subclass' cells
     *  should look like
     */
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        println("Override me! (collectionView cellForItemAtIndexPath)")
        return UICollectionViewCell()
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        println("Override me! (collectionView numberOfItemsInSection)")
        return 0
    }
    
    /**
     * Default initialization.  Set up the collection view, its gesture recognizers and delegates
     *  You may want to override this with more specific initializations.
     */
    override init(frame: CGRect) {
        let collectionFrame = CGRect(origin: CGPointZero, size: frame.size)
        collectionView = UICollectionView(frame: collectionFrame, collectionViewLayout: DraggableCollectionLayout())
        
        collectionView.backgroundColor = UIColor.clearColor()
        
        super.init(frame: frame)
        
        backgroundColor = UIColor.clearColor()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        let gestureRecognizer = UIPanGestureRecognizer(target: self, action: "doPanGesture:")
        gestureRecognizer.delegate = self
        gestureRecognizer.cancelsTouchesInView = false
        collectionView.addGestureRecognizer(gestureRecognizer)
        
        collectionView.panGestureRecognizer.cancelsTouchesInView = false
        collectionView.panGestureRecognizer.enabled = false
        addSubview(collectionView)
    }
    
    
    /**** BEGIN UIGestureRecognizerDelegate stuff ****/
    
    /** Increase this to make it harder to scroll and easier to pull parts from the bar. */
    let ANGLE_THRESHHOLD = π / 12
    /**
     * Make sure the gesture recognizer only triggers when the user drags at a greater angle than ANGLE_THRESHHOLD.
     * Otherwise we should assume they're trying to drag the scrollView.
     */
    override func gestureRecognizerShouldBegin(gestureRecognizer: UIGestureRecognizer) -> Bool {
        if gestureRecognizer is UIPanGestureRecognizer {
            let panGesture = gestureRecognizer as UIPanGestureRecognizer
            let x = panGesture.velocityInView(self.collectionView).x
            let y = panGesture.velocityInView(self.collectionView).y
            
            let angle = atan(y/x)
            
            if fabs(angle) < ANGLE_THRESHHOLD {
                collectionView.scrollEnabled = true
                return false
            }
            else {
                collectionView.scrollEnabled = false
                collectionView.userInteractionEnabled = false
                return true
            }
        }
        collectionView.scrollEnabled = false
        return true
    }
    
    /**
     * Handle a pan gesture from the user.  If it's on top of a cell, notify the subclass it needs to do something.
     *  We call a bunch of different methods depending on if the user just started/continued/finished a touch,
     *  which are all handled differently by different subclasses.
     */
    func doPanGesture(gestureRec: UIGestureRecognizer) {
        if gestureRec is UIPanGestureRecognizer {
            let panGestureRec: UIPanGestureRecognizer = gestureRec as UIPanGestureRecognizer
            
            var touchPoint = panGestureRec.locationInView(self.superview!)
            
            /** STATE = BEGAN **/
            var scrollPoint = panGestureRec.locationInView(self)
            scrollPoint.x += collectionView.contentOffset.x
            if panGestureRec.state == UIGestureRecognizerState.Began {
                for subview in collectionView.visibleCells() {
                    if subview.frame.contains(scrollPoint) {
                        startDraggingCell(subview as UIView)
                    }
                }
                collectionView.userInteractionEnabled = true
                collectionView.scrollEnabled = false
            }
                
            /** STATE = CHANGED **/
            else if panGestureRec.state == UIGestureRecognizerState.Changed {
                continueDraggingCell(touchPoint)
            }
                
            /** STATE = ENDED **/
            else if panGestureRec.state == UIGestureRecognizerState.Ended ||
                panGestureRec.state == UIGestureRecognizerState.Cancelled {
                    stoppedDraggingCell()
                    collectionView.scrollEnabled = true
                    collectionView.userInteractionEnabled = true
            }
                
            else if panGestureRec.state == .Failed {
                stoppedDraggingCell()
                collectionView.userInteractionEnabled = true
            }
        }
    }
    
    /** The user just dragged a cell off the view.  Tell the subclass to handle it. */
    func startDraggingCell(cell: UIView) {
        println("Override me! (startDraggingCell)")
    }
    
    /** The user is dragging a cell around the screen. */
    func continueDraggingCell(position: CGPoint) {
        println("Override me! (continueDraggingCell)")
    }
    
    /** The user stopped dragging a cell */
    func stoppedDraggingCell() {
        println("Override me! (stoppedDraggingCell)")
    }
    
    /** Make sure the collection view's inherent gesture recs don't override ours */
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) can not been implemented")
    }
}