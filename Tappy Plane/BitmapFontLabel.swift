//
//  BitmapFontLabel.swift
//  Tappy Plane
//
//  Created by David Pirih on 20.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

enum Alignment: Int {
    case BitmapFontAlignmentLeft = 0
    case BitmapFontAlignmentCenter
    case BitmapFontAlignmentRight
}

class BitmapFontLabel: SKNode {
   
    var fontName: String = "" {
        didSet {
            if fontName != oldValue {
                updateText()
            }
        }
    }
    var text: NSString = "" {
        didSet {
            if text != oldValue {
                updateText()
            }
        }
    }
    var letterSpacing:CGFloat = 0.0 {
        didSet {
            if letterSpacing != oldValue {
                updateText()
            }
        }
    }
    var alignment: Alignment = .BitmapFontAlignmentCenter {
        didSet {
            if alignment != oldValue {
                updateText()
            }
        }
    }
    
    
    convenience init(text: String, fontName: String) {
        self.init()
        
        self.text = text
        self.fontName = fontName
        self.letterSpacing = 2.0
        self.alignment = .BitmapFontAlignmentCenter
        self.updateText()
    }
    
    func updateText(){
        // Remove unused node
        if self.text.length < self.children.count {
            for var i = self.children.count; i > self.text.length; i-- {
                (self.children as NSArray).objectAtIndex(i-1).removeFromParent()
            }
        }
        
        let altas = SKTextureAtlas(named: "Graphics")
        
        var pos = CGPointZero
        var totalSize = CGSizeZero
        // Loop through all characters in text
        for var i = 0; i < self.text.length; i++ {
            // Get character in text for curent position in loop
            var c = self.text.characterAtIndex(i)
            let textureName = "\(fontName)\(NSString(bytes: &c, length: 1, encoding: NSUTF8StringEncoding)!)"
            
            var letter:SKSpriteNode!
            if i < self.children.count {
                // Reuse an existing node
                letter = (self.children as NSArray).objectAtIndex(i) as SKSpriteNode
                letter.texture = altas.textureNamed(textureName)
                letter.size = letter.texture!.size()
            }
            else {
                letter = SKSpriteNode(texture: altas.textureNamed(textureName))
                letter.anchorPoint = CGPointZero
                self.addChild(letter)
            }
            
            letter.position = pos
            
            pos.x += letter.size.width + letterSpacing
            totalSize.width += letter.size.width + letterSpacing
            if totalSize.height < letter.size.height {
                totalSize.height = letter.size.height
            }
        }
        
        if self.text.length > 0 {
            totalSize.width -= self.letterSpacing
        }
    
        // Align text
        var adjustment: CGPoint
        
        switch alignment {
        case .BitmapFontAlignmentLeft:
            adjustment = CGPointMake(0.0, -totalSize.height * 0.5)
        case .BitmapFontAlignmentCenter:
            adjustment = CGPointMake(-totalSize.width * 0.5, -totalSize.height * 0.5)
        case .BitmapFontAlignmentRight:
            adjustment = CGPointMake(-totalSize.width, -totalSize.height * 0.5)
        default:
            println("Error: Invalid alignment type!")
        }
        
        
        for letter in self.children {
            (letter as SKNode).position = CGPointMake(letter.position.x + adjustment.x, letter.position.y + adjustment.y)
        }
        
    }
    
}
