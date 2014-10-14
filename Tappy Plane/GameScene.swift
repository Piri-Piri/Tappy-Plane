//
//  GameScene.swift
//  Tappy Plane
//
//  Created by David Pirih on 13.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    var player: Plane!
    var world: SKNode!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        world = SKNode()
        self.addChild(world)
        
        player = Plane()
        player.position = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height * 0.5)
        world.addChild(player)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
