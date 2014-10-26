//
//  Button.swift
//  Tappy Plane
//
//  Created by David Pirih on 25.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

class Button: SKSpriteNode {
   
    private var fullSizeFrame: CGRect = CGRectNull
    
    var pressedScale: CGFloat = 0.0
    
    override init(texture: SKTexture!, color: UIColor!, size: CGSize) {
        super.init(texture: texture, color: color, size: size)
        
        self.pressedScale = 0.9
        self.userInteractionEnabled = true
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            self.fullSizeFrame = self.frame
            self.touchesMoved(touches, withEvent: event)
        }
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            if CGRectContainsPoint(self.fullSizeFrame, touch.locationInNode(self.parent)) {
                self.setScale(self.pressedScale)
            }
            else {
                self.setScale(1.0)
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.setScale(1.0)
        for touch: AnyObject in touches {
            if CGRectContainsPoint(self.fullSizeFrame, touch.locationInNode(self.parent)) {
                // Pressed button
                
            }
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        for touch: AnyObject in touches {
            self.setScale(1.0)
        }
    }
    
}
