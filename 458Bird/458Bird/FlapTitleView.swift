//
//  FlapTitleView.swift
//  458Bird
//
//  Created by Elliot Fiske on 1/15/15.
//  Copyright (c) 2015 Elliot Fiske. All rights reserved.
//

import UIKit

class FlapTitleView: UIView {
    private let mainMessage = UILabel()
    private let subMessage = UILabel()
    private let fontSize: CGFloat = 24
    private let smallerFontSize: CGFloat = 18
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = UIColor(white: 0, alpha: 0.3)
        
        let randomString = "Whatever"
        let randomNSString = randomString as! NSString
        
        let titleLabelSize = randomNSString.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(fontSize)])
        mainMessage.frame = CGRect(x: 0, y: 0, width: frame.width, height: titleLabelSize.height)
        mainMessage.center.y = frame.center.y
        mainMessage.font = UIFont.systemFontOfSize(fontSize)
        mainMessage.textColor = UIColor.whiteColor()
        mainMessage.textAlignment = .Center
        addSubview(mainMessage)
        
        let messageLabelSize = randomNSString.sizeWithAttributes([NSFontAttributeName:UIFont.systemFontOfSize(smallerFontSize)])
        subMessage.frame = CGRect(x: 0, y: mainMessage.frame.origin.y + mainMessage.frame.height, width: frame.width, height: messageLabelSize.height)
        subMessage.font = UIFont.systemFontOfSize(smallerFontSize)
        subMessage.textColor = UIColor(white: 0.8, alpha: 1)
        subMessage.textAlignment = .Center
        addSubview(subMessage)
    }

    func showTitle() {
        mainMessage.text = "Flappy Monster"
        subMessage.text = "Created by Elliot Fiske for CSC 458"
    }
    
    func showGameOver(score: Int) {
        mainMessage.text = "GAME OVER!!!"
        subMessage.text = "Score: \(score)"
    }
    
    func showPaused() {
        mainMessage.text = "Paused"
        subMessage.text = "Tap to continue"
    }
    
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not not not been implemented")
    }
}
