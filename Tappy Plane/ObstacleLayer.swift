//
//  ObstacleLayer.swift
//  Tappy Plane
//
//  Created by David Pirih on 19.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

class ObstacleLayer: ScrollingNode {
   
    let kMarkerBuffer:CGFloat = 200.0
    //let kVerticalGap:CGFloat = 90.0
    let kVerticalGap:CGFloat = 140.0
    let kSpaceBetweenObstacleSets:CGFloat = 180.0
    
    let kCollectableVerticalRange:CGFloat = 200.0
    let KCollectableClearance: CGFloat = 50.0
    
    let kMountainUpKey = "mountainUp"
    let kMountainDownKey = "mountainDown"
    let kCollectableStarKey = "CollectableStar"
    
    var marker:CGFloat = 0.0
    var floor:CGFloat = 0.0
    var ceiling:CGFloat = 0.0
    
    var delegate: CollectableDelegate!
    
    override init() {
        super.init()
        
        // Load initial objects and make them reusable
        for var i = 0; i < 6; i++ {
            self.createObjectForKey(kMountainUpKey).position = CGPointMake(-1000.0, 0.0)
            self.createObjectForKey(kMountainDownKey).position = CGPointMake(-1000.0, 0.0)
        }
    }
    
    func reset() {
        // loop through child nodes and reposition for reuse and update texture
        for node in self.children {
            (node as SKSpriteNode).position = CGPointMake(-1000, 0)
            if (node as SKSpriteNode).name == kMountainUpKey {
                (node as SKSpriteNode).texture = TilesetTextureProvider.sharedInstance().getTextureForKey(kMountainUpKey)
            }
            if (node as SKSpriteNode).name == kMountainDownKey {
                (node as SKSpriteNode).texture = TilesetTextureProvider.sharedInstance().getTextureForKey(kMountainDownKey)
            }
        }
        
        // reposition marker 
        if scene != nil {
            marker = scene!.size.width + kMarkerBuffer
        }
    }
    
    override func updateWithTimeElpased(timeElpased: NSTimeInterval) {
        super.updateWithTimeElpased(timeElpased)
        
        if isScrolling && scene != nil {
            // Find makers loaction inscenes coords
            let markerLocationInScene = self.convertPoint(CGPointMake(marker, 0), toNode: scene!)
            // When marker comes onto screen, add new obstacles
            if markerLocationInScene.x - (scene!.size.width * scene!.anchorPoint.x) < scene!.size.width + kMarkerBuffer {
                addObstacleSet()
            }
        }
    }
    
    func addObstacleSet() {
        // Get Mountain nodes
        let mountainUp = self.getUnusedObjectForKey(kMountainUpKey)
        let mountainDown = self.getUnusedObjectForKey(kMountainDownKey)
        
        // Calculate maximum variation
        let maxVariation = (mountainUp.size.height + kVerticalGap + mountainDown.size.height) - (ceiling - floor)
        let yAdjustment = CGFloat(arc4random_uniform(UInt32(maxVariation)))
        
        // Position mountain nodes
        mountainUp.position = CGPointMake(marker, floor + (mountainUp.size.height * 0.5) - yAdjustment)
        mountainDown.position = CGPointMake(marker, mountainUp.position.y + mountainDown.size.height + kVerticalGap)
        
        // Get collectable star node
        let collectable = self.getUnusedObjectForKey(kCollectableStarKey)
        
        // Position collectable
        let midPoint = mountainUp.position.y + (mountainUp.size.height * 0.5) + (kVerticalGap * 0.5)
        var yPosition = midPoint + CGFloat(arc4random_uniform(UInt32(kCollectableVerticalRange))) - (kCollectableVerticalRange * 0.5)
        yPosition = fmax(yPosition, floor + KCollectableClearance)
        yPosition = fmin(yPosition, ceiling - KCollectableClearance)
        
        collectable.position = CGPointMake(marker + (kSpaceBetweenObstacleSets * 0.5), yPosition)
        
        // Reposition marker
        marker += kSpaceBetweenObstacleSets
    }
    
    func getUnusedObjectForKey(key: String) -> SKSpriteNode {
        if scene != nil {
            // Get left edge of screen in local coordinates
            let leftEdgeInLocalCoords = (scene?.convertPoint(CGPointMake(-scene!.size.width * scene!.anchorPoint.x , 0), toNode: self))?.x
            
            // Try find object for key to the left of the scene
            for node in self.children {
                if node.name == key && node.frame.origin.x + node.frame.size.width < leftEdgeInLocalCoords {
                    // Return unused object
                    return node as SKSpriteNode
                }
            }
        }
        
        // Couldn't find an unused object with key, so create a new one
        return self.createObjectForKey(key)
    }
    
    func createObjectForKey(key: String) -> SKSpriteNode {
        let atlas = SKTextureAtlas(named: "Graphics")
        
        var sprite:SKSpriteNode!
        if key == kMountainUpKey {
            //println("Create Mountion Up")
            sprite = SKSpriteNode(texture: TilesetTextureProvider.sharedInstance().getTextureForKey(kMountainUpKey))
            
            let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
            let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
            var path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, 55 - offsetX, 199 - offsetY);
            CGPathAddLineToPoint(path, nil, 0 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 90 - offsetX, 0 - offsetY);
            CGPathCloseSubpath(path);
            
            sprite.physicsBody = SKPhysicsBody(edgeLoopFromPath: path!)
            sprite.physicsBody?.categoryBitMask = kGroundCategory
            
            self.addChild(sprite)
        }
        else if key == kMountainDownKey {
            // println("Create Mountion Down")
            sprite = SKSpriteNode(texture: TilesetTextureProvider.sharedInstance().getTextureForKey(kMountainDownKey))
            
            let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
            let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
            var path = CGPathCreateMutable();
            CGPathMoveToPoint(path, nil, 0 - offsetX, 199 - offsetY);
            CGPathAddLineToPoint(path, nil, 55 - offsetX, 0 - offsetY);
            CGPathAddLineToPoint(path, nil, 90 - offsetX, 199 - offsetY);
            CGPathCloseSubpath(path);
            
            sprite.physicsBody = SKPhysicsBody(edgeLoopFromPath: path!)
            sprite.physicsBody?.categoryBitMask = kGroundCategory
            
            self.addChild(sprite)
        }
        else if key == kCollectableStarKey {
            sprite = Collectable(texture: atlas.textureNamed("StarGold"))
            
            (sprite as Collectable).pointValue = 1
            (sprite as Collectable).delegate = self.delegate
            
            sprite.physicsBody = SKPhysicsBody(circleOfRadius: sprite.size.width * 0.3)
            sprite.physicsBody?.categoryBitMask = kCollectableCategory
            sprite.physicsBody?.dynamic = false
            
            self.addChild(sprite)
        }
        
        if sprite != nil {
            sprite.name = key
        }
        return sprite
    }
}
