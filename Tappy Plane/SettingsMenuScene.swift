//
//  SettingsMenuScene.swift
//  Tappy Plane
//
//  Created by David Pirih on 11.11.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import SpriteKit

class SettingsMenuScene: SKScene {
    
    var normalButton: Button!
    var challengeButton: Button!
    var tapButton: Button!
    var flapButton: Button!
    
    override init(size: CGSize) {
        super.init(size: size)
        
        // Set Background color to sky blue
        self.backgroundColor = SKColor(red: 0.835294118, green: 0.929411765, blue: 0.968627451, alpha: 1.0)
        
        // Setup title node
        let title = SKLabelNode(fontNamed: "Futura")
        title.text = "Settings"
        title.fontColor = SKColor(red: 0.9450980392, green: 0.8, blue: 0.2117647059, alpha: 1.0)
        title.fontSize = 30
        title.position = CGPointMake(size.width * 0.5, size.height - 40)
        self.addChild(title)
        
        // Get texture atlas
        let altas = SKTextureAtlas(named: "Graphics")
        
        // Setup node to act as group for panel elements
        let panelGroup = SKNode()
        self.addChild(panelGroup)
        
        // Setup background panel
        let panelBackground = SKSpriteNode(texture: altas.textureNamed("UIbg"))
        panelBackground.position = CGPointMake(size.width * 0.5, size.height - 150.0)
        panelBackground.centerRect = CGRectMake(10 / panelBackground.size.width,
            10 / panelBackground.size.height,
            (panelBackground.size.width - 20) / panelBackground.size.width,
            (panelBackground.size.height - 20) / panelBackground.size.height)
        panelBackground.xScale = 275.0 / panelBackground.size.width
        panelBackground.yScale = 195.0 / panelBackground.size.height
        panelGroup.addChild(panelBackground)
        
        // Setup game mode buttons
        let gameModeTitle = SKLabelNode(fontNamed: "Futura")
        gameModeTitle.text = "Game Mode"
        gameModeTitle.fontColor = SKColor.whiteColor()
        gameModeTitle.fontSize = 22
        gameModeTitle.position = CGPointMake(CGRectGetMidX(panelBackground.frame) , CGRectGetMaxY(panelBackground.frame) - 30)
        panelGroup.addChild(gameModeTitle)
        
        normalButton = Button(texture: altas.textureNamed("buttonNormal"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: altas.textureNamed("buttonNormal").size())
        normalButton.position = CGPointMake(CGRectGetMidX(panelBackground.frame) - 50 , CGRectGetMaxY(panelBackground.frame) - 60)
        normalButton.setPressedAction(pressedNormalButton)
        normalButton.pressedSound = Sound(named: "Click.caf")
        normalButton.userInteractionEnabled = NSUserDefaults.standardUserDefaults().boolForKey("ChallengeGameMode")
        normalButton.enabled = NSUserDefaults.standardUserDefaults().boolForKey("ChallengeGameMode")
        panelGroup.addChild(normalButton)
        
        challengeButton = Button(texture: altas.textureNamed("buttonChallenge"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: altas.textureNamed("buttonChallenge").size())
        challengeButton.position = CGPointMake(CGRectGetMidX(panelBackground.frame) + 50 , CGRectGetMaxY(panelBackground.frame) - 60)
        challengeButton.setPressedAction(pressedChallengeButton)
        challengeButton.pressedSound = Sound(named: "Click.caf")
        challengeButton.userInteractionEnabled = !normalButton.userInteractionEnabled
        challengeButton.enabled = !normalButton.enabled
        panelGroup.addChild(challengeButton)
        
        // Setup control mode buttons
        let controlModeTitle = SKLabelNode(fontNamed: "Futura")
        controlModeTitle.text = "Control Mode"
        controlModeTitle.fontColor = SKColor.whiteColor()
        controlModeTitle.fontSize = 22
        controlModeTitle.position = CGPointMake(CGRectGetMidX(panelBackground.frame), CGRectGetMinY(panelBackground.frame) + 80)
        panelGroup.addChild(controlModeTitle)
        
        tapButton = Button(texture: altas.textureNamed("buttonTap"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: altas.textureNamed("buttonTap").size())
        tapButton.position = CGPointMake(CGRectGetMidX(panelBackground.frame) - 50 , CGRectGetMinY(panelBackground.frame) + 50)
        tapButton.setPressedAction(pressedTapButton)
        tapButton.pressedSound = Sound(named: "Click.caf")
        tapButton.userInteractionEnabled = NSUserDefaults.standardUserDefaults().boolForKey("FlapControlMode")
        tapButton.enabled = NSUserDefaults.standardUserDefaults().boolForKey("FlapControlMode")
        panelGroup.addChild(tapButton)
        
        flapButton = Button(texture: altas.textureNamed("buttonFlap"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: altas.textureNamed("buttonFlap").size())
        flapButton.position = CGPointMake(CGRectGetMidX(panelBackground.frame) + 50 , CGRectGetMinY(panelBackground.frame) + 50)
        flapButton.setPressedAction(pressedFlapButton)
        flapButton.pressedSound = Sound(named: "Click.caf")
        flapButton.userInteractionEnabled = !tapButton.userInteractionEnabled
        flapButton.enabled = !tapButton.enabled
        panelGroup.addChild(flapButton)
        
        
        let backButton = Button(texture: altas.textureNamed("buttonBack"), color: UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.0), size: altas.textureNamed("buttonBack").size())
        backButton.position = CGPointMake(CGRectGetMidX(panelBackground.frame), CGRectGetMinY(panelBackground.frame) - 30)
        backButton.setPressedAction(pressedBackButton)
        backButton.pressedSound = Sound(named: "Click.caf")
        panelGroup.addChild(backButton)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func pressedNormalButton() {
        normalButton.enabled = false
        normalButton.userInteractionEnabled = false
        challengeButton.enabled = !normalButton.enabled
        challengeButton.userInteractionEnabled = !normalButton.userInteractionEnabled
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "ChallengeGameMode")
        NSUserDefaults.standardUserDefaults().setValue(GameMode.Normal.rawValue, forKey: "GameMode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func pressedChallengeButton() {
        challengeButton.enabled = false
        challengeButton.userInteractionEnabled = false
        normalButton.enabled = !challengeButton.enabled
        normalButton.userInteractionEnabled = !challengeButton.userInteractionEnabled
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "ChallengeGameMode")
        NSUserDefaults.standardUserDefaults().setValue(GameMode.Challenge.rawValue, forKey: "GameMode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func pressedTapButton() {
        tapButton.enabled = false
        tapButton.userInteractionEnabled = false
        flapButton.enabled = !tapButton.enabled
        flapButton.userInteractionEnabled = !tapButton.userInteractionEnabled
        
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: "FlapControlMode")
        NSUserDefaults.standardUserDefaults().setValue(ControlMode.Tap.rawValue, forKey: "ControlMode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func pressedFlapButton() {
        flapButton.enabled = false
        flapButton.userInteractionEnabled = false
        tapButton.enabled = !flapButton.enabled
        tapButton.userInteractionEnabled = !flapButton.userInteractionEnabled
        
        NSUserDefaults.standardUserDefaults().setBool(true, forKey: "FlapControlMode")
        NSUserDefaults.standardUserDefaults().setValue(ControlMode.Flap.rawValue, forKey: "ControlMode")
        NSUserDefaults.standardUserDefaults().synchronize()
    }
    
    func pressedBackButton() {
        // Switch back to game menu
        if let skView = self.view {
            skView.presentScene(GameScene(size: self.size), transition: SKTransition.pushWithDirection(SKTransitionDirection.Right, duration: 0.6))
        }
    }
}
