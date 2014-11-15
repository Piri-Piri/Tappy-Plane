//
//  ChallengeProvider.swift
//  Tappy Plane
//
//  Created by David Pirih on 11.11.14.
//  Copyright (c) 2014 Piri-Piri. All rights reserved.
//

import UIKit
import SpriteKit


class ChallengeItem {
    
    var obstacleKey: NSString!
    var position: CGPoint!
    
    class func challengeItemWithKey(key: String, andPosition position:(CGPoint)) -> ChallengeItem {
        let item = ChallengeItem()
        item.obstacleKey = key
        item.position = position
        return item
    }
}

class ChallengeProvider {
    
    var challenges = NSMutableArray()

    class func sharedInstance() -> ChallengeProvider {
        struct Provider {
            static let instance = ChallengeProvider()
        }
        return Provider.instance
    }

    init() {
        loadChallenges()
    }

    func loadChallenges() {
        // Challenge 1
        var challenge = NSMutableArray()
        challenge.addObject(ChallengeItem.challengeItemWithKey(kMountainUpKey, andPosition:CGPointMake(0, 105)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kMountainDownKey, andPosition:CGPointMake(143, 250)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kCollectableStarKey, andPosition:CGPointMake(23, 290)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kCollectableStarKey, andPosition:CGPointMake(128, 35)))
        self.challenges.addObject(challenge)
        
        // Challenge 2
        challenge = NSMutableArray()
        challenge.addObject(ChallengeItem.challengeItemWithKey(kMountainUpKey, andPosition:CGPointMake(90, 25)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kMountainDownAlternateKey, andPosition:CGPointMake(0, 232)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kCollectableStarKey, andPosition:CGPointMake(100, 243)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kCollectableStarKey, andPosition:CGPointMake(152, 205)))
        self.challenges.addObject(challenge)
        
        // Challenge 3
        challenge = NSMutableArray()
        challenge.addObject(ChallengeItem.challengeItemWithKey(kMountainUpKey, andPosition:CGPointMake(0, 82)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kMountainUpAlternateKey, andPosition:CGPointMake(122, 0)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kMountainDownKey, andPosition:CGPointMake(85, 320)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kCollectableStarKey, andPosition:CGPointMake(10, 213)))
        challenge.addObject(ChallengeItem.challengeItemWithKey(kCollectableStarKey, andPosition:CGPointMake(81, 116)))
        self.challenges.addObject(challenge)
    }
    
    func getRandomChallenge() -> NSArray {
        return self.challenges.objectAtIndex(Int(arc4random_uniform(UInt32(self.challenges.count)))) as NSArray
    }

}
