//
//  Plane.swift
//  Tappy Plane
//
//  Created by David Pirih on 14.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

class Plane: SKSpriteNode {
    
    override init() {
        let plane = SKTexture(imageNamed: "planeBlue1@2x")
        super.init(texture: plane, color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: plane.size())
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
