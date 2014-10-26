//
//  ScrollingLayer.swift
//  Tappy Plane
//
//  Created by David Pirih on 16.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

class ScrollingLayer: ScrollingNode {
    
    var mostRightTile: SKSpriteNode!
    
    convenience init(tiles: NSArray) {
        self.init()
        
        for tile:AnyObject in tiles {
            let sprite = tile as SKSpriteNode
            sprite.anchorPoint = CGPointZero
            sprite.name = "Tile"
            self.addChild(sprite)
        }
        self.layoutTiles()
    }
    
    func layoutTiles() {
        mostRightTile = SKSpriteNode()
        self.enumerateChildNodesWithName("Tile", usingBlock: { (node, stop) -> Void in
            
            node.position = CGPointMake(self.mostRightTile.position.x + self.mostRightTile.size.width, node.position.y)
            self.mostRightTile = node as SKSpriteNode
            
        })
    }
    
    override func updateWithTimeElpased(timeElpased: NSTimeInterval) {
        super.updateWithTimeElpased(timeElpased)
        
        // rotate tile - falling off the left side add it to the right again
        if isScrolling && horizontalScrollSpeed < 0 && self.scene != nil {
            self.enumerateChildNodesWithName("Tile", usingBlock: { (node, stop) -> Void in
                var nodePositionInScene = self.convertPoint(node.position, toNode: self.scene!)
                
                /* get the left edge of the scene even, if an other anchor point is used */
                let leftEdgeOfScene = -self.scene!.frame.size.width * self.scene!.anchorPoint.x
                
                if nodePositionInScene.x + node.frame.size.width < leftEdgeOfScene {
                    node.position = CGPointMake(self.mostRightTile.position.x + self.mostRightTile.size.width, node.position.y)
                    self.mostRightTile = node as SKSpriteNode
                }
            })
        }
        
    }
}
