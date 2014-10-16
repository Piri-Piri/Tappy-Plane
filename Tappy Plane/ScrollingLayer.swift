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
            (tile as SKSpriteNode).anchorPoint = CGPointZero
            (tile as SKSpriteNode).name = "Tile"
            self.addChild((tile as SKSpriteNode))
        }
        self.layoutTiles()
    }
    
    func layoutTiles() {
        self.enumerateChildNodesWithName("Tile", usingBlock: { (node, stop) -> Void in
            node.position = CGPointMake(self.mostRightTile.position.x + self.mostRightTile.size.width, node.position.y)
            self.mostRightTile = node as SKSpriteNode
        })
    }
    
    override func updateWithTimeElpased(timeElpased: NSTimeInterval) {
        super.updateWithTimeElpased(timeElpased)
        
        // rotate tile - faaling off the left side add it to the right again
        if isScrolling && horizontalScrollSpeed < 0 && self.scene != nil {
         
            self.enumerateChildNodesWithName("Tile", usingBlock: { (node, stop) -> Void in
                var nodePositionInScene = self.convertPoint(node.position, fromNode: self.scene!)
                
                /* get the left edge of the scene even, if an other anchor point is used */
                let leftEdgeOfScene = -self.scene!.size.width * self.scene!.anchorPoint.x
                
                if nodePositionInScene.x + node.frame.size.width < leftEdgeOfScene {
                    node.position = CGPointMake(self.mostRightTile.position.x + self.mostRightTile.size.width, node.position.y)
                    self.mostRightTile = node as SKSpriteNode
                }
            })
        }
        
    }
}
