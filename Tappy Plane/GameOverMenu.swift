//
//  GameOverMenu.swift
//  Tappy Plane
//
//  Created by David Pirih on 26.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

enum MedalType: Int {
    case MedalNone = 0
    case MedalBronze
    case MedalSilver
    case MedalGold
}

protocol GameOverMenuDelegate {

    func pressedStartNewGameButton()
    
}

class GameOverMenu: SKNode {
    
    private var medalDisplay: SKSpriteNode!

    var delegate: GameOverMenuDelegate!
    
    var size: CGSize = CGSizeZero
    var score: Int = 0 {
        didSet {
            scoreText.text = "\(score)"
        }
    }
    var bestScore: Int = 0 {
        didSet {
            bestScoreText.text = "\(bestScore)"
        }
    }
    var medal: MedalType = .MedalNone {
        didSet {
            switch medal {
            case .MedalBronze:
                medalDisplay.texture = SKTextureAtlas(named: "Graphics").textureNamed("medalBronze")
            case .MedalSilver:
                medalDisplay.texture = SKTextureAtlas(named: "Graphics").textureNamed("medalSilver")
            case .MedalGold:
                medalDisplay.texture = SKTextureAtlas(named: "Graphics").textureNamed("medalGold")
            default:
                medalDisplay.texture = SKTextureAtlas(named: "Graphics").textureNamed("medalBlank")
            }
        }
    }
    var scoreText: BitmapFontLabel!
    var bestScoreText: BitmapFontLabel!
    var gameOverTitle: SKSpriteNode!
    var panelGroup: SKNode!
    var playButton: Button!
    
    
    convenience init(size: CGSize) {
        self.init()
        self.size = size
        
        // Get texture atlas
        let altas = SKTextureAtlas(named: "Graphics")
        
        // Setup game over title
        gameOverTitle = SKSpriteNode(texture: altas.textureNamed("textGameOver"))
        gameOverTitle.position = CGPointMake(size.width * 0.5, size.height - 70.0)
        self.addChild(gameOverTitle)

        // Setup node to act as group for panel elements
        panelGroup = SKNode()
        panelGroup.alpha = 0.0
        self.addChild(panelGroup)

        // Setup background panel
        let panelBackground = SKSpriteNode(texture: altas.textureNamed("UIbg"))
        panelBackground.position = CGPointMake(size.width * 0.5, size.height - 150.0)
        panelBackground.centerRect = CGRectMake(10 / panelBackground.size.width,
                                                10 / panelBackground.size.height,
                                                (panelBackground.size.width - 20) / panelBackground.size.width,
                                                (panelBackground.size.height - 20) / panelBackground.size.height)
        panelBackground.xScale = 175.0 / panelBackground.size.width
        panelBackground.yScale = 115.0 / panelBackground.size.height
        panelGroup.addChild(panelBackground)
        
        // Setup score title
        let scoreTitle = SKSpriteNode(texture: altas.textureNamed("textScore"))
        scoreTitle.anchorPoint = CGPointMake(1.0, 1.0)
        scoreTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20.0, CGRectGetMaxY(panelBackground.frame) - 10.0)
        panelGroup.addChild(scoreTitle)
        
        // Setup score text
        scoreText = BitmapFontLabel(text: "0", fontName: "number")
        scoreText.alignment = .BitmapFontAlignmentRight
        scoreText.position = CGPointMake(CGRectGetMaxX(scoreTitle.frame), CGRectGetMinY(scoreTitle.frame) - 15.0)
        scoreText.setScale(0.5)
        panelGroup.addChild(scoreText)

        // Setup best title
        let bestTitle = SKSpriteNode(texture: altas.textureNamed("textBest"))
        bestTitle.anchorPoint = CGPointMake(1.0, 1.0)
        bestTitle.position = CGPointMake(CGRectGetMaxX(panelBackground.frame) - 20.0, CGRectGetMaxY(panelBackground.frame) - 60.0)
        panelGroup.addChild(bestTitle)
        
        // Setup best text
        bestScoreText = BitmapFontLabel(text: "0", fontName: "number")
        bestScoreText.alignment = .BitmapFontAlignmentRight
        bestScoreText.position = CGPointMake(CGRectGetMaxX(bestTitle.frame), CGRectGetMinY(bestTitle.frame) - 15.0)
        bestScoreText.setScale(0.5)
        panelGroup.addChild(bestScoreText)
        
        // Setup medal title
        let medalTitle = SKSpriteNode(texture: altas.textureNamed("textMedal"))
        medalTitle.anchorPoint = CGPointMake(0.0, 1.0)
        medalTitle.position = CGPointMake(CGRectGetMinX(panelBackground.frame) + 20.0, CGRectGetMaxY(panelBackground.frame) - 10.0)
        panelGroup.addChild(medalTitle)
        
        // Setup display of medal
        medalDisplay = SKSpriteNode(texture: altas.textureNamed("medalBlank"))
        medalDisplay.anchorPoint = CGPointMake(0.5, 1.0)
        medalDisplay.position = CGPointMake(CGRectGetMidX(medalTitle.frame), CGRectGetMinY(medalTitle.frame) - 15.0)
        panelGroup.addChild(medalDisplay)
        
        // Setup play button
        playButton = Button(texture: altas.textureNamed("buttonPlay"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: altas.textureNamed("buttonPlay").size())
        playButton.position = CGPointMake(CGRectGetMidX(panelBackground.frame) , CGRectGetMinY(panelBackground.frame) - 25.0)
        playButton.setPressedAction(pressedPlayButton)
        playButton.pressedSound = Sound(named: "Click.caf")
        self.addChild(playButton)
    }
    
    func pressedPlayButton() {
        delegate.pressedStartNewGameButton()
    }
    
    func show() {
        // Animate game over title
        let dropGameOverText = SKAction.moveByX(0.0, y:-100.0, duration:0.5)
        dropGameOverText.timingMode = SKActionTimingMode.EaseOut
        gameOverTitle.position = CGPointMake(gameOverTitle.position.x, gameOverTitle.position.y + 100.0)
        gameOverTitle.runAction(dropGameOverText)
        
        // Animate main menu panle
        let raisePanel = SKAction.group([SKAction.fadeInWithDuration(0.4), SKAction.moveByX(0.0, y:100.0, duration:0.4)])
        raisePanel.timingMode = SKActionTimingMode.EaseOut
        panelGroup.alpha = 0.01 // crashs on 0.0 -> bug!?
        panelGroup.position = CGPointMake(panelGroup.position.x, panelGroup.position.y - 100.0)
        panelGroup.runAction(SKAction.sequence([SKAction.waitForDuration(0.7), raisePanel]))
        
        // Animate play button
        let fadeInPlayButton = SKAction.sequence([SKAction.waitForDuration(1.2), SKAction.fadeInWithDuration(0.4)])
        playButton.alpha = 0.0
        playButton.userInteractionEnabled = false
        playButton.runAction(SKAction.sequence([fadeInPlayButton, SKAction.runBlock( { self.playButton.userInteractionEnabled = true } )]))
    }
}
