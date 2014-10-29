//
//  Plane.swift
//  Tappy Plane
//
//  Created by David Pirih on 14.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

let kPlaneCategory:UInt32           = 0x1 << 0
let kGroundCategory:UInt32          = 0x1 << 1
let kCollectableCategory: UInt32    = 0x1 << 2

class Plane: SKSpriteNode {
    
    let kPlanAnimationKey: String = "PlaneAnimation"
    let kMaxAltitude: CGFloat = 350.0
    
    var planeAnimations: NSMutableArray!
    var isEngineRunning: Bool = false {
        didSet {
            isEngineRunning = isEngineRunning && !isCrashed
            if isEngineRunning {
                self.engineSound.play()
                self.engineSound.fadeIn(1.0)
                /* avoid that puff effects is follows the plane (looks not realistic) */
                self.puffTrailEmitter.targetNode = self.parent
                
                self.actionForKey(kPlanAnimationKey)?.speed = 1.0
                self.puffTrailEmitter.particleBirthRate = puffTrailBirthRate
            }
            else {
                self.engineSound.fadeOut(0.5)
                self.actionForKey(kPlanAnimationKey)?.speed = 0.0
                self.puffTrailEmitter.particleBirthRate = 0.0
            }
        }
    }
    var isAccelerating: Bool = false {
        didSet {
            isAccelerating = isAccelerating && !isCrashed
        }
    }
    var isCrashed: Bool = false {
        didSet {
            if isCrashed {
                isEngineRunning = false
                isAccelerating = false
            }
        }
    }
    
    var puffTrailEmitter:SKEmitterNode!
    var puffTrailBirthRate:CGFloat = 0.0
    
    var crashedTintAction: SKAction!
    var engineSound: Sound!
    
    
    
    override init() {
        let plane = SKTexture(imageNamed: "planeBlue1@2x")
        super.init(texture: plane, color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: plane.size())
        
        // Setup physics body with path.
        let offsetX = self.frame.size.width * self.anchorPoint.x;
        let offsetY = self.frame.size.height * self.anchorPoint.y;
        var planeBodyPath = CGPathCreateMutable();
        CGPathMoveToPoint(planeBodyPath, nil, 43 - offsetX, 18 - offsetY);
        CGPathAddLineToPoint(planeBodyPath, nil, 34 - offsetX, 36 - offsetY);
        CGPathAddLineToPoint(planeBodyPath, nil, 11 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(planeBodyPath, nil, 0 - offsetX, 28 - offsetY);
        CGPathAddLineToPoint(planeBodyPath, nil, 10 - offsetX, 4 - offsetY);
        CGPathAddLineToPoint(planeBodyPath, nil, 29 - offsetX, 0 - offsetY);
        CGPathAddLineToPoint(planeBodyPath, nil, 37 - offsetX, 5 - offsetY);
        CGPathCloseSubpath(planeBodyPath);
        self.physicsBody = SKPhysicsBody(polygonFromPath: planeBodyPath)
        
//        var bodyShape = SKShapeNode()
//        bodyShape.path = planeBodyPath
//        bodyShape.strokeColor = SKColor(red: 1.0, green: 0, blue: 0, alpha: 0.5)
//        bodyShape.lineWidth = 2.0
//        
//        self.addChild(bodyShape)
        
        self.physicsBody?.mass = 0.08
        self.physicsBody?.categoryBitMask = kPlaneCategory
        self.physicsBody?.collisionBitMask = kGroundCategory
        self.physicsBody?.contactTestBitMask = kGroundCategory | kCollectableCategory
        
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
        
        // Setup action to tint plane whenit crashed
        let tint = SKAction.colorizeWithColor(SKColor.redColor(), colorBlendFactor: 0.8, duration: 0.0)
        let removeTint = SKAction.colorizeWithColorBlendFactor(0.0, duration: 0.2)
        crashedTintAction = SKAction.sequence([tint,removeTint])
        
        // Setup engine sound
        engineSound = Sound(named: "Engine.caf")
        engineSound.looping = true
        
        setRandomColor()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func animationFromArray(textureNames: NSArray, withDuration: CGFloat) -> SKAction {
        // Create Array to hold planes
        var frames: NSMutableArray = NSMutableArray()
        
        let planes = SKTextureAtlas(named: "Graphics")
        
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
    
    func reset() {
        isCrashed = false
        isEngineRunning = true
        self.physicsBody?.velocity = CGVectorMake(0.0, 0.0)
        self.zRotation = 0.0
        self.physicsBody?.angularVelocity = 0.0
        setRandomColor()
    }
    
    func update() {
        if isAccelerating && self.position.y < kMaxAltitude {
            self.physicsBody?.applyForce(CGVectorMake(0.0, 100.0))
        }
        if !isCrashed {
            self.zRotation = fmax(fmin(self.physicsBody!.velocity.dy, 400), -400) / 400
            self.engineSound.volume = Float(0.35 + fmax(fmin(self.physicsBody!.velocity.dy, 300), 0) / 300 * 0.65)
        }
    }
    
    func collideWithBody(body:SKPhysicsBody) {
        // Ignore collisions if already crashed
        if !isCrashed {
            if body.categoryBitMask == kGroundCategory {
                // Hit the ground
                isCrashed = true
                self.runAction(crashedTintAction)
                SoundManager.sharedManager().playSound("Crunch.caf")
            }
            if body.categoryBitMask == kCollectableCategory {
                // Remove the star 
                if body.node!.respondsToSelector(Selector("collect")) {
                    (body.node! as Collectable).collect()
                }
            }
        }
    }
}
