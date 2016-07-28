//
//  ShadowComponent.swift
//  DinoDefense
//
//  Created by Anko Top on 26/07/16.
//  Copyright © 2016 REactivity. All rights reserved.
//

import Foundation
import GameplayKit
import SpriteKit

class ShadowComponent: GKComponent {

    let node: SKShapeNode

    init(size: CGSize, offset: CGPoint) {
        node = SKShapeNode(ellipseOfSize: size)
        node.fillColor = SKColor.blackColor()
        node.strokeColor = SKColor.blackColor()
        node.alpha = 0.2
        node.position = offset
    }
}