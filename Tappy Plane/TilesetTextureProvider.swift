//
//  TilesetTextureProvider.swift
//  Tappy Plane
//
//  Created by David Pirih on 24.10.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit

let kTileSetGrass   = "Grass"
let kTileSetDirt    = "Dirt"
let kTileSetIce     = "Ice"
let kTileSetSnow    = "Snow"

class TilesetTextureProvider {
    
    var tilesets = NSMutableDictionary()
    var currentTileset = NSDictionary()
    var currentTilesetName: String = ""
    
    class func sharedInstance() -> TilesetTextureProvider {
        struct Provider {
            static let instance = TilesetTextureProvider()
        }
        return Provider.instance
    }
    
    init() {
        loadTilesets()
        randomizeTilesets()
    }
    
    func getTextureForKey(key: String) -> SKTexture {
        return currentTileset.objectForKey(key) as SKTexture
    }
    
    func randomizeTilesets() {
        let tilesetKeys:NSArray = tilesets.allKeys
        let randomKey = tilesetKeys.objectAtIndex(Int(arc4random_uniform(UInt32(tilesetKeys.count)))) as String
        currentTileset = tilesets.objectForKey(randomKey) as NSDictionary
        currentTilesetName = randomKey
    }
    
    func loadTilesets() {
        let atlas = SKTextureAtlas(named: "Graphics")
        
        // Get path to property list
        if let plistPath = NSBundle.mainBundle().pathForResource("TilesetGraphics", ofType: "plist") {
            // Load contents of file
            if let tilesetList = NSDictionary(contentsOfFile: plistPath) {
                // Loop through tilesetList
                for tilesetKey in tilesetList.allKeys {
                    // Get dictionary of texture names
                    var textureList = tilesetList.objectForKey(tilesetKey) as NSDictionary
                    // Create dictionary to hold textures
                    var textures = NSMutableDictionary()
                    
                    for textureKey in textureList.allKeys {
                        // Get texture for key
                        let texture = atlas.textureNamed(textureList.objectForKey(textureKey as String) as String)
                        // Insert textrure to texture dictionary
                        textures.setObject(texture, forKey: textureKey as String)
                    }
                    
                    // Add textures dictionary to tileset
                    tilesets.setObject(textures, forKey: (tilesetKey as String))
                }
            }
        }
    }
   
}
