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
    
    let kPlanAnimationKey: String = "PlaneAnimation"
    
    var planeAnimations: NSMutableArray!
    var isEngineRunning: Bool = false {
        didSet {
            /* avoid that puff effects is follows the plane (looks not realistic) */
            self.puffTrailEmitter.targetNode = self.parent
            if isEngineRunning {
                self.actionForKey(kPlanAnimationKey)?.speed = 1.0
                self.puffTrailEmitter.particleBirthRate = puffTrailBirthRate
            }
            else {
                self.actionForKey(kPlanAnimationKey)?.speed = 0.0
                self.puffTrailEmitter.particleBirthRate = 0.0
            }
        }
    }
    var isAccelerating: Bool = false
    
    var puffTrailEmitter:SKEmitterNode!
    var puffTrailBirthRate:CGFloat = 0.0
    
    
    
    override init() {
        let plane = SKTexture(imageNamed: "planeBlue1@2x")
        super.init(texture: plane, color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: plane.size())
        
        // Setup PhysicsBody
        self.physicsBody = SKPhysicsBody(circleOfRadius: self.size.width * 0.5)
        self.physicsBody?.mass = 0.08
        
        // Init Array to hold animation actions
        planeAnimations = NSMutableArray()
        
        // load animations from plist
        let path = NSBundle.mainBundle().pathForResource("PlaneAnimations", ofType: "plist")
        var animations:NSMutableDictionary = NSMutableDictionary(contentsOfFile: path!)!
        
        for key: AnyObject in (animations.allKeys as NSArray) {
            let action = self.animationFromArray(animations.objectForKey(key) as NSArray, withDuration: 0.4)
            planeAnimations.addObject(action)
        }
        
        // Setup puff trail particle effect
        let particleFile = NSBundle.mainBundle().pathForResource("PlanePuffTrail", ofType: "sks")
        puffTrailEmitter = NSKeyedUnarchiver.unarchiveObjectWithFile(particleFile!) as SKEmitterNode
        puffTrailEmitter.position = CGPointMake(-self.size.width * 0.5, -5)
        self.addChild(puffTrailEmitter)
        self.puffTrailBirthRate = puffTrailEmitter.particleBirthRate
        // initial value
        puffTrailEmitter.particleBirthRate = 0
        
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
        self.removeActionForKey(kPlanAnimationKey)
        let animation = planeAnimations.objectAtIndex(Int(arc4random_uniform(UInt32(planeAnimations.count)))) as SKAction
        self.runAction(animation, withKey: kPlanAnimationKey)
        if !isEngineRunning {
            self.actionForKey(kPlanAnimationKey)?.speed = 0.0
        }
    }
    
    func update() {
        if isAccelerating {
            self.physicsBody?.applyForce(CGVectorMake(0.0, 100.0))
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
