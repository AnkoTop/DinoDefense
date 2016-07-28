//
//  AnimationComponent.swift
//  DinoDefense
//
//  Created by Anko Top on 26/07/16.
//  Copyright © 2016 REactivity. All rights reserved.
//

import SpriteKit
import GameplayKit

enum AnimationState: String {
    case Idle = "Idle"
    case Walk = "Walk"
    case Hit = "Hit"
    case Dead = "Dead"
    case Attacking = "Attacking"
}

struct Animation {
    let animationState: AnimationState
    let textures: [SKTexture]
    let repeatTexturesForever: Bool
}

class AnimationComponent: GKComponent {

    var requestedAnimationState: AnimationState?
    
    // 1
    let node: SKSpriteNode
 
    // 2
    var animations: [AnimationState: Animation]
 
    // 3
    private(set) var currentAnimation: Animation?
 
    // 4
    init(node: SKSpriteNode, textureSize: CGSize,
         animations: [AnimationState: Animation]) {
        self.node = node
        self.animations = animations
    }
    
    override func updateWithDeltaTime(deltaTime: NSTimeInterval) {
        super.updateWithDeltaTime(deltaTime)
        if let animationState = requestedAnimationState {
            runAnimationForAnimationState(animationState)
            requestedAnimationState = nil
        }
        
        
    }
    
    class func animationFromAtlas(atlas: SKTextureAtlas, withImageIdentifier identifier: String, forAnimationState animationState: AnimationState, repeatTexturesForever: Bool = true) -> Animation {
        let textures = atlas.textureNames.filter {
            $0.hasPrefix("\(identifier)_")
            }.sort {
                $0 < $1
            }.map {
                atlas.textureNamed($0)
        }
  
        return Animation(
            animationState: animationState,
            textures: textures,
            repeatTexturesForever: repeatTexturesForever
        )
    }
    
    private func runAnimationForAnimationState(animationState: AnimationState) {
        
        // 1
        let actionKey = "Animation"
        
        // 2
        let timePerFrame = NSTimeInterval(1.0 / 30.0)
        
        // 3
        if currentAnimation != nil && currentAnimation!.animationState == animationState { return }
        
        // 4
        guard let animation = animations[animationState] else {
            print("Unknown animation for state \(animationState.rawValue)")
            return
        }
        
        // 5
        node.removeActionForKey(actionKey)
        
        // 6
        let texturesAction: SKAction
        if animation.repeatTexturesForever {
            texturesAction = SKAction.repeatActionForever(
                SKAction.animateWithTextures(
                    animation.textures, timePerFrame: timePerFrame))
        } else {
            texturesAction = SKAction.animateWithTextures(
                animation.textures, timePerFrame: timePerFrame)
        }
        
        // 7
        node.runAction(texturesAction, withKey: actionKey)
        
        // 8
        currentAnimation = animation
    }
}
