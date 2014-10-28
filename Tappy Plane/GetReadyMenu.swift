//
//  GetReadyMenu.swift
//  Tappy Plane
//
//  Created by David Pirih on 28.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

class GetReadyMenu: SKNode {

    var size: CGSize!
    var getReadyText: SKSpriteNode!
    var tapGroup: SKNode!
    
    convenience init(size: CGSize, planePosition: CGPoint) {
        self.init()
        self.size = size
        
        // Get texture atlas
        let atlas = SKTextureAtlas(named: "Graphics")
        
        // Setup get ready text
        getReadyText = SKSpriteNode(texture: atlas.textureNamed("textGetReady"))
        getReadyText.position = CGPointMake(size.width * 0.75, planePosition.y)
        self.addChild(getReadyText)
        
        // Setup group for tap related nodes
        tapGroup = SKNode()
        tapGroup.position = planePosition
        self.addChild(tapGroup)
        
        // Setup right tap tag
        let rightTapTag = SKSpriteNode(texture: atlas.textureNamed("tapLeft"))
        rightTapTag.position = CGPointMake(55.0, 0.0)
        tapGroup.addChild(rightTapTag)
        
        // Setup left tap tag
        let leftTapTag = SKSpriteNode(texture: atlas.textureNamed("tapRight"))
        leftTapTag.position = CGPointMake(-55.0, 0.0)
        tapGroup.addChild(leftTapTag)
        
        // Get frames for tap animation
        let tapAnimationFrames = [atlas.textureNamed("tap"), atlas.textureNamed("tapTick"), atlas.textureNamed("tapTick")]
        
        // Create action for tap animation
        let tapAnimation = SKAction.animateWithTextures(tapAnimationFrames, timePerFrame: 0.5 , resize: true, restore: false)
        
        // Setup tap hand
        let tapHand = SKSpriteNode(texture: atlas.textureNamed("tap"))
        tapHand.position = CGPointMake(0.0, -40.0)
        tapGroup.addChild(tapHand)
        tapHand.runAction(SKAction.repeatActionForever(tapAnimation))
    }
    
    
    func show() {
        // Reset nodes
        tapGroup.alpha = 1.0
        getReadyText.position = CGPointMake(size.width * 0.75, getReadyText.position.y)
    }
    
    func hide() {
        // Create action to fade out tap group
        let fadeTapGroup = SKAction.fadeOutWithDuration(0.5)
        tapGroup.runAction(fadeTapGroup)
        
        // Create action to slide get ready text
        let slideLeft = SKAction.moveByX(-30.0, y:0.0, duration:0.2)
        slideLeft.timingMode = SKActionTimingMode.EaseInEaseOut
        
        let slideRight = SKAction.moveToX(size.width + (getReadyText.size.width * 0.5), duration:0.6)
        slideRight.timingMode = SKActionTimingMode.EaseIn
        
        // Slide get ready text of the right
        getReadyText.runAction(SKAction.sequence([slideLeft, slideRight]))
    }
    
}
