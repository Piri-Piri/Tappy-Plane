//
//  ScrollingNode.swift
//  Tappy Plane
//
//  Created by David Pirih on 16.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

class ScrollingNode: SKNode {
   
    let horizontalScrollSpeed: CGFloat = 0.0 // distance to scroll per second
    var isScrolling: Bool = false
 
    func updateWithTimeElpased(timeElpased: NSTimeInterval) {
        if isScrolling {
            self.position = CGPointMake(self.position.x + (horizontalScrollSpeed * CGFloat(timeElpased)), self.position.y)
        }
    }

}
  