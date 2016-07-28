//
//  ProjectileEntity.swift
//  DinoDefense
//
//  Created by Anko Top on 28/07/16.
//  Copyright © 2016 REactivity. All rights reserved.
//

import SpriteKit
import GameplayKit

class ProjectileEntity: GKEntity {
    var spriteComponent: SpriteComponent!
    init(towerType: TowerType) {
        super.init()
        
        let texture = SKTexture(imageNamed: "\(towerType.rawValue)Projectile")
        spriteComponent = SpriteComponent(entity: self, texture: texture, size: texture.size())
        addComponent(spriteComponent)
    }
}
