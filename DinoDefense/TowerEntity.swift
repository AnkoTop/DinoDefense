//
//  TowerEntity.swift
//  DinoDefense
//
//  Created by Anko Top on 28/07/16.
//  Copyright © 2016 REactivity. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit

enum TowerType: String {
    case Wood = "WoodTower"
    case Rock = "RockTower"
    static let allValues = [Wood, Rock]
    
    var fireRate: Double {
        switch self {
        case Wood: return 1.0
        case Rock: return 1.5
        }
    }
    
    var damage: Int {
        switch self {
        case Wood: return 20
        case Rock: return 50
        }
    }
    
    var range: CGFloat {
        switch self {
        case Wood: return 200
        case Rock: return 250
        }
    }
}

class TowerEntity: GKEntity {
    let towerType: TowerType
    var spriteComponent: SpriteComponent!
    var shadowComponent: ShadowComponent!
    var animationComponent: AnimationComponent!
    var firingComponent: FiringComponent!

    init(towerType: TowerType) {

        // Store the TowerType
        self.towerType = towerType
        super.init()
        
        let textureAtlas = SKTextureAtlas(named: towerType.rawValue)
        let defaultTexture = textureAtlas.textureNamed("Idle__000")
        let textureSize = CGSizeMake(98, 140)
        
        // Add the SpriteComponent
        spriteComponent = SpriteComponent(entity: self, texture: defaultTexture, size: textureSize)
        addComponent(spriteComponent)
        
        // Add the ShadowComponent
        let shadowSize = CGSizeMake(98, 44)
        shadowComponent = ShadowComponent(size: shadowSize, offset: CGPointMake(0.0, -textureSize.height/2 + shadowSize.height/2))
        addComponent(shadowComponent)
        
        // Add the AnimationComponent
        animationComponent = AnimationComponent(node: spriteComponent.node, textureSize: textureSize, animations: loadAnimations())
        addComponent(animationComponent)
        
        // Add the FiringComponent
        firingComponent = FiringComponent(towerType: towerType, parentNode: spriteComponent.node)
        addComponent(firingComponent)
    }
    
    func loadAnimations() -> [AnimationState: Animation] {
        let textureAtlas = SKTextureAtlas(named: towerType.rawValue)
        var animations = [AnimationState: Animation]()
        
        animations[.Idle] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: "Idle",
            forAnimationState: .Idle)
        animations[.Attacking] = AnimationComponent.animationFromAtlas(
            textureAtlas,
            withImageIdentifier: "Attacking",
            forAnimationState: .Attacking)
     
        return animations
    }
}