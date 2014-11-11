//
//  GameScene.swift
//  Tappy Plane
//
//  Created by David Pirih on 13.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import SpriteKit

enum GameMode: Int {
    case Normal
    case Challenge
}

enum ControlMode: Int {
    case Tap
    case Flap
}

enum GameState: Int {
    case GameReady
    case GameRunning
    case GameOver
}

let kMountainUpKey      = "mountainUp"
let kMountainDownKey    = "mountainDown"
let kCollectableStarKey = "CollectableStar"

class GameScene: SKScene, SKPhysicsContactDelegate, CollectableDelegate, GameOverMenuDelegate {
    
    let kMinFPS = 10.0 / 60.0
    let kBestScoreKey = "BestScore"
    
    var lastCallTime: CFTimeInterval = 0
    
    var player: Plane!
    var world: SKNode!
    var background:ScrollingLayer!
    var obstacles:ObstacleLayer!
    var foreground:ScrollingLayer!
    var weather:WeatherLayer!
    var scoreLabel:BitmapFontLabel!
    
    var gameMode: GameMode = .Normal
    var controlMode: ControlMode = .Tap

    var gameOverMenu: GameOverMenu!
    var getReadyMenu: GetReadyMenu!
    var gameState: GameState = .GameReady
    
    var settingsMenu: SettingsMenuScene!
    
    var score:Int = 0 {
        didSet {
            scoreLabel.text = "\(score)"
        }
    }
    var bestScore: Int = 0
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        // Init audio
        SoundManager.sharedManager().prepareToPlayWithSound("Crunch.caf")
        
        // Set Background color to sky blue
        self.backgroundColor = SKColor(red: 0.835294118, green: 0.929411765, blue: 0.968627451, alpha: 1.0)
        
        // Get atlas file
        let graphics = SKTextureAtlas(named: "Graphics")
        
        // Setup Physics
        if controlMode == .Tap {
            self.physicsWorld.gravity = CGVectorMake(0.0, -5.5)
        }
        else {
            self.physicsWorld.gravity = CGVectorMake(0.0, -4.0)
        }
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
        obstacles.gameMode = gameMode
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
        
        // Setup weather
        weather = WeatherLayer(size: view.frame.size)
        world.addChild(weather)
        
        // Setup score label
        scoreLabel = BitmapFontLabel(text: "0", fontName: "number")
        scoreLabel.position = CGPointMake(view.frame.size.width * 0.5, view.frame.size.height - 100)
        self.addChild(scoreLabel)
        
        // Load best score
        bestScore = NSUserDefaults.standardUserDefaults().integerForKey(kBestScoreKey)
        
        // Setup game over menu
        gameOverMenu = GameOverMenu(size: view.frame.size)
        gameOverMenu.delegate = self
        
        // Setup get ready menu
        getReadyMenu = GetReadyMenu(size: view.frame.size, planePosition: CGPointMake(view.frame.size.width * 0.3, view.frame.size.height * 0.5))
        getReadyMenu.zPosition = 1.0
        self.addChild(getReadyMenu)
        
        // Setup setting scene
        settingsMenu = SettingsMenuScene(size: view.frame.size)

        // Start a new game
        newGame()
    }
    
    func generateGroundTile() -> SKSpriteNode {
        let altas = SKTextureAtlas(named: "Graphics")
        let sprite = SKSpriteNode(texture: altas.textureNamed("groundGrass"))
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
        
        // Setup weather conditions
        let tilesetName = TilesetTextureProvider.sharedInstance().currentTilesetName
        weather.conditions = .WeatherClear
        
        if tilesetName == kTileSetIce || tilesetName == kTileSetSnow {
            // 1 in 2 chance for snow on snow and ice tilesets
            if Int(arc4random_uniform(UInt32(2))) == 0 {
                weather.conditions = .WeatherSnow
            }
        }
        if tilesetName == kTileSetGrass || tilesetName == kTileSetDirt {
            // 1 in 3 chance for rain on crass and dirt tilesets
            if Int(arc4random_uniform(UInt32(3))) == 0 {
                weather.conditions = .WeatherRain
            }
        }
        
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
        scoreLabel.alpha = 1.0
        
        // Reset plane
        player.position = CGPointMake(self.frame.size.width * 0.3, self.frame.size.height * 0.5)
        player.physicsBody?.affectedByGravity = false
        player.reset()
        
        // Set game state to ready
        gameState = .GameReady
    }
    
    func gameOver() {
        // Update game state
        gameState = .GameOver
        // Fade out score display
        scoreLabel.runAction(SKAction.fadeOutWithDuration(0.4))
        // Set properties on game over menu
        gameOverMenu.score = score
        gameOverMenu.medal = getMedaForCurrentScore()
        // Update best score
        if score > bestScore {
            bestScore = score
            NSUserDefaults.standardUserDefaults().setInteger(bestScore, forKey: kBestScoreKey)
            NSUserDefaults.standardUserDefaults().synchronize()
        }
        gameOverMenu.bestScore = bestScore
        // Show game over menu
        self.addChild(gameOverMenu)
        gameOverMenu.show()
    }
    
    func pressedStartNewGameButton() {
        let blackRect = SKSpriteNode(color: SKColor.blackColor(), size: size)
        blackRect.anchorPoint = CGPointZero
        blackRect.alpha = 0.0
        self.addChild(blackRect)
        
        let startNewGame = SKAction.runBlock { () -> Void in
            self.newGame()
            self.gameOverMenu.removeFromParent()
            self.getReadyMenu.show()
        }
        
        let fadeTransition = SKAction.sequence([SKAction.fadeInWithDuration(0.4),
                                                startNewGame,
                                                SKAction.fadeOutWithDuration(0.6),
                                                SKAction.removeFromParent()])
        blackRect.runAction(fadeTransition)
    }
    
    func bump() {
        let bump = SKAction.sequence([SKAction.moveBy(CGVectorMake(-5.0, -0.4), duration: 0.1), SKAction.moveTo(CGPointZero, duration: 0.1)])
        world.runAction(bump)
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        if gameState == .GameReady {
            getReadyMenu.hide()
            player.physicsBody?.affectedByGravity = true
            obstacles.isScrolling = true
            gameState = .GameRunning
        }
        
        if gameState == .GameRunning {
            if controlMode == .Tap {
                player.isAccelerating = true
            }
            else {
                player.flap()
            }
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if gameState == .GameRunning {
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
        
        if gameState == .GameRunning && player.isCrashed {
            // Player just crashed in last frame so trigger game over
            bump()
            gameOver()
        }
        
        if gameState != .GameOver {
            background.updateWithTimeElpased(timeElapsed)
            obstacles.updateWithTimeElpased(timeElapsed)
            foreground.updateWithTimeElpased(timeElapsed)
        }
    }
    
    func getMedaForCurrentScore() -> MedalType {
        var adjustedScore = score - (bestScore / 5)
        
        if adjustedScore >= 45 {
            return .MedalGold
        }
        else if adjustedScore >= 25 {
            return .MedalSilver
        }
        else if adjustedScore >= 10 {
            return .MedalBronze
        }
        return .MedalNone
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
