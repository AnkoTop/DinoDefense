//
//  DinosaurEntity.swift
//  DinoDefense
//
//  Created by Anko Top on 26/07/16.
//  Copyright © 2016 REactivity. All rights reserved.
//

import UIKit
import GameplayKit
import SpriteKit

enum DinosaurType: String {
    case TRex = "T-Rex"
    case Triceratops = "Triceratops"
    case TRexBoss = "T-RexBoss"
}

class DinosaurEntity: GKEntity {

    // 1
    let dinosaurType: DinosaurType
    var spriteComponent: SpriteComponent!
    var shadowComponent: ShadowComponent!
    var animationComponent: AnimationComponent!
 
    // 2
    init(dinosaurType: DinosaurType) {
        self.dinosaurType = dinosaurType
        super.init()
    
        // 3
        let size: CGSize
        switch dinosaurType {
        case .TRex, .TRexBoss:
            size = CGSizeMake(203, 110)
        case .Triceratops:
            size = CGSizeMake(142, 74)
        }
        
        // 4
        let textureAtlas = SKTextureAtlas(named: dinosaurType.rawValue)
        let defaultTexture = textureAtlas.textureNamed("Walk__01.png")
   
        // 5 spritecomponent
        spriteComponent = SpriteComponent(entity: self, texture: defaultTexture, size: size)
        addComponent(spriteComponent)
        
        // 6 shadowcomponent
        let shadowSize = CGSizeMake(size.width, size.height * 0.3)
        shadowComponent = ShadowComponent(size: shadowSize, offset: CGPointMake(0.0, -size.height/2 + shadowSize.height/2))
        addComponent(shadowComponent)
        
        // 7 animationcomponent
        animationComponent = AnimationComponent(node: spriteComponent.node,textureSize: size, animations: loadAnimations())
        addComponent(animationComponent)
    }
    
    func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: dinosaurType.rawValue)
        var animations = [AnimationState: Animation]()
        animations[.Walk] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: "Walk",
            forAnimationState: .Walk)
        animations[.Hit] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: "Hurt",
            forAnimationState: .Hit,
            repeatTexturesForever: false)
        animations[.Dead] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: "Dead",
            forAnimationState: .Dead,
            repeatTexturesForever: false)
        return animations
    }
}