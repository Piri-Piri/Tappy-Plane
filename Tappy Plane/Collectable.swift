//
//  Collectable.swift
//  Tappy Plane
//
//  Created by David Pirih on 20.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

protocol CollectableDelegate {
    
    func wasCollected(collectable: Collectable)
    
}

class Collectable: SKSpriteNode {
   
    var delegate: CollectableDelegate!
    var collectionSound: Sound!
    var pointValue: Int = 0
    
    func collect() {
        self.collectionSound.play()
        self.runAction(SKAction.removeFromParent())
        if let delegate = self.delegate {
            self.delegate.wasCollected(self)
        }
    }
    
}
