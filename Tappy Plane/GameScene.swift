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
        
        // Setup Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5)
        
        // Setup World
        world = SKNode()
        self.addChild(world)
        
        // Setup Player
        player = Plane()
        player.position = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height * 0.5)
        player.physicsBody?.affectedByGravity = false
        world.addChild(player)
        
        player.isEngineRunning = true
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            player.physicsBody?.affectedByGravity = true
           self.player.isAccelerating = true
        
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            self.player.isAccelerating = false
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        self.player.update()
    }
}
