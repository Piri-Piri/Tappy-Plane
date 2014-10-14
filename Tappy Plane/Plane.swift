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
    
    var planeAnimations: NSMutableArray!
    
    override init() {
        let plane = SKTexture(imageNamed: "planeBlue1@2x")
        super.init(texture: plane, color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: plane.size())
        
        // Init Array to hold animation actions
        planeAnimations = NSMutableArray()
        
        // load animations from plist
        let path = NSBundle.mainBundle().pathForResource("PlaneAnimations", ofType: "plist")
        var animations:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!)!
        
        for key: AnyObject in (animations.allKeys as NSArray) {
            let action = self.animationFromArray(animations.objectForKey(key) as NSArray, withDuration: 0.4)
            planeAnimations.addObject(action)
        }
        setRandomColor()
        
    }
    
    func animationFromArray(textureNames: NSArray, withDuration: CGFloat) -> SKAction {
        // Create Array to hold planes
        var frames: NSMutableArray = NSMutableArray()
        
        let planes = SKTextureAtlas(named: "Planes")
        
        // Loop through textures array
        for textureName in textureNames {
            frames.addObject(planes.textureNamed(textureName as String))
        }
        
        // calc time per frame
        let frameTime = Double(withDuration) / Double(frames.count)
        
        // Create Animation and return as SKAction
        let animation = SKAction.repeatActionForever(SKAction.animateWithTextures(frames, timePerFrame: frameTime, resize: false, restore: false))
        return animation
    }
    
    func setRandomColor() {
        self.runAction(planeAnimations.objectAtIndex(Int(arc4random_uniform(UInt32(planeAnimations.count)))) as SKAction)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
