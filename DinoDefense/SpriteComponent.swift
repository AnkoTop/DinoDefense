//
//  SpriteComponent.swift
//  DinoDefense
//
//  Created by Anko Top on 26/07/16.
//  Copyright © 2016 REactivity. All rights reserved.
//

import SpriteKit
import GameplayKit

class EntityNode: SKSpriteNode {
    weak var entity: GKEntity!
}

class SpriteComponent: GKComponent {

    // A node that gives an entity a visual sprite
    let node: EntityNode

    init(entity: GKEntity, texture: SKTexture, size: CGSize) {
        node = EntityNode(texture: texture,
                          color: SKColor.whiteColor(), size: size)
        node.entity = entity
    }
}