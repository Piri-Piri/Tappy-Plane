//
//  WeatherLayer.swift
//  Tappy Plane
//
//  Created by David Pirih on 29.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

enum WeatherType: Int {
    case WeatherClear = 0
    case WeatherSnow
    case WeatherRain
}

class WeatherLayer: SKNode {
    
    var size: CGSize!
    var conditions: WeatherType = .WeatherClear {
        didSet {
            // Remove all weather effects
            self.removeAllChildren()
            
            // Stop any exiting sounds from playing
            if rainSound.playing {
                rainSound.fadeOut(1.0)
            }
            
            // Add weather conditions
            switch conditions {
            case .WeatherSnow:
                self.addChild(snowEffect)
                self.snowEffect.advanceSimulationTime(5)
            case .WeatherRain:
                
                self.rainSound.play()
                self.rainSound.fadeIn(1.0)
                self.rainSound.volume = 0.25
                self.addChild(rainEffect)
                self.rainEffect.advanceSimulationTime(5)
            default:
                break
            }
        }
    }
    
    var snowEffect: SKEmitterNode!
    var rainEffect: SKEmitterNode!
    var rainSound: Sound!
    
    convenience init(size: CGSize) {
        self.init()
        self.size = size
        
        // Load snow effect
        let snowEffectPath = NSBundle.mainBundle().pathForResource("SnowEffect", ofType: "sks")
        snowEffect = NSKeyedUnarchiver.unarchiveObjectWithFile(snowEffectPath!) as SKEmitterNode
        snowEffect.position = CGPointMake(size.width * 0.5, size.height + 5)
        
        // Setup rain sound
        rainSound = Sound(named: "Rain.caf")
        rainSound.looping = true
        
        // Load rain effect
        let rainEffectPath = NSBundle.mainBundle().pathForResource("RainEffect", ofType: "sks")
        rainEffect = NSKeyedUnarchiver.unarchiveObjectWithFile(rainEffectPath!) as SKEmitterNode
        rainEffect.position = CGPointMake(size.width * 0.5 + 32, size.height + 5)
        
    }
}
