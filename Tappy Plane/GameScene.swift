//
//  GameScene.swift
//  Tappy Plane
//
//  Created by David Pirih on 13.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import SpriteKit

class GameScene: SKScene, SKPhysicsContactDelegate, CollectableDelegate {
    
    let kMinFPS = 10.0 / 60.0
    
    var lastCallTime: CFTimeInterval = 0
    
    var player: Plane!
    var world: SKNode!
    var background:ScrollingLayer!
    var obstacles:ObstacleLayer!
    var foreground:ScrollingLayer!
    var scoreLabel:BitmapFontLabel!
    
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Set Background color to sky blue
        self.backgroundColor = SKColor(red: 0.835294118, green: 0.929411765, blue: 0.968627451, alpha: 1.0)
        
        // Get atlas file
        let graphics = SKTextureAtlas(named: "Graphics")
        
        // Setup Physics
        self.physicsWorld.gravity = CGVectorMake(0.0, -5.5)
        self.physicsWorld.contactDelegate = self
        
        // Setup World
        world = SKNode()
        self.addChild(world)
        
        // Setup Background
        var backgroundTiles = NSMutableArray()
        for var i = 0; i < 3; i++ {
            backgroundTiles.addObject(SKSpriteNode(texture: graphics.textureNamed("background@2x")))
        }
        background = ScrollingLayer(tiles: backgroundTiles)
        background.horizontalScrollSpeed = -60.0 
        background.isScrolling = true
        world.addChild(background)
        
        // Setup obstacle layer
        obstacles = ObstacleLayer()
        obstacles.delegate = self
        obstacles.horizontalScrollSpeed = -80
        obstacles.isScrolling = true
        obstacles.floor = 0.0
        obstacles.ceiling = view.frame.size.height
        world.addChild(obstacles)
        
        // Setup Foreground
        foreground = ScrollingLayer(tiles: [self.generateGroundTile(),self.generateGroundTile(),self.generateGroundTile()])
        foreground.horizontalScrollSpeed = -80.0
        foreground.isScrolling = true
        world.addChild(foreground)
        
        // Setup Player
        player = Plane()
        player.physicsBody?.affectedByGravity = false
        world.addChild(player)
        
        // Setup score label
        scoreLabel = BitmapFontLabel(text: "0", fontName: "number")
        scoreLabel.position = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height - 100)
        self.addChild(scoreLabel)
        
        // Setup Test Button
        var button = Button(texture: graphics.textureNamed("buttonPlay"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: graphics.textureNamed("buttonPlay").size())
        button.position = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height * 0.5)
        button.zPosition = 1.0

        self.addChild(button)
        
        // Start a new game
        newGame()
    }
    
    func generateGroundTile() -> SKSpriteNode {
        let graphics = SKTextureAtlas(named: "Graphics")
        let sprite = SKSpriteNode(texture: graphics.textureNamed("groundGrass"))
        sprite.anchorPoint = CGPointZero;
        
        let offsetX = sprite.frame.size.width * sprite.anchorPoint.x;
        let offsetY = sprite.frame.size.height * sprite.anchorPoint.y;
        var path = CGPathCreateMutable();
        CGPathMoveToPoint(path, nil, 403 - offsetX, 15 - offsetY);
        CGPathAddLineToPoint(path, nil, 367 - offsetX, 35 - offsetY);
        CGPathAddLineToPoint(path, nil, 329 - offsetX, 34 - offsetY);
        CGPathAddLineToPoint(path, nil, 287 - offsetX, 7 - offsetY);
        CGPathAddLineToPoint(path, nil, 235 - offsetX, 11 - offsetY);
        CGPathAddLineToPoint(path, nil, 205 - offsetX, 28 - offsetY);
        CGPathAddLineToPoint(path, nil, 168 - offsetX, 20 - offsetY);
        CGPathAddLineToPoint(path, nil, 122 - offsetX, 33 - offsetY);
        CGPathAddLineToPoint(path, nil, 76 - offsetX, 31 - offsetY);
        CGPathAddLineToPoint(path, nil, 46 - offsetX, 11 - offsetY);
        CGPathAddLineToPoint(path, nil, 0 - offsetX, 16 - offsetY);
        sprite.physicsBody = SKPhysicsBody(edgeChainFromPath: path)
        sprite.physicsBody?.categoryBitMask = kGroundCategory
        
//        var bodyShape = SKShapeNode()
//        bodyShape.path = path
//        bodyShape.strokeColor = SKColor(red: 1.0, green: 0, blue: 0, alpha: 0.5)
//        bodyShape.lineWidth = 2.0
//        
//        sprite.addChild(bodyShape)
    
        return sprite
    }
    
    func newGame() {
        // Randomize tileset
        TilesetTextureProvider.sharedInstance().randomizeTilesets()
        
        // Reset layers
        foreground.position = CGPointZero
        for node in foreground.children {
            (node as SKSpriteNode).texture = TilesetTextureProvider.sharedInstance().getTextureForKey("ground")
        }
        foreground.layoutTiles()
        obstacles.position = CGPointZero
        obstacles.reset()
        obstacles.isScrolling = false
        background.position = CGPointMake(0.0, 30.0)
        background.layoutTiles()
        
        // Reset score
        score = 0
        
        // Reset plane
        player.position = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * 0.5)
        player.physicsBody?.affectedByGravity = false
        player.reset()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            if player.isCrashed {
                // Reset game
                newGame()
            }
            else {
                player.physicsBody?.affectedByGravity = true
                player.isAccelerating = true
                obstacles.isScrolling = true
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        for touch: AnyObject in touches {
            player.isAccelerating = false
        }
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
        var timeElapsed = currentTime - lastCallTime
        if timeElapsed > kMinFPS {
            timeElapsed = kMinFPS
        }
        lastCallTime = currentTime
        
        player.update()
        if !player.isCrashed {
            background.updateWithTimeElpased(timeElapsed)
            obstacles.updateWithTimeElpased(timeElapsed)
            foreground.updateWithTimeElpased(timeElapsed)
        }
    }
    
    // MARK: SKPhysicsContactDelegate
    
    func didBeginContact(contact: SKPhysicsContact) {
        if contact.bodyA.categoryBitMask == kPlaneCategory {
            player.collideWithBody(contact.bodyB)
        }
        else if contact.bodyB.categoryBitMask == kPlaneCategory {
            player.collideWithBody(contact.bodyA)
        }
    }
    
    // MARK: CollectableDelegate
    
    func wasCollected(collectable: Collectable) {
        self.score += collectable.pointValue
    }
    

}
