//
//  HealthComponent.swift
//  DinoDefense
//
//  Created by Anko Top on 03/08/16.
//  Copyright © 2016 REactivity. All rights reserved.
//

import SpriteKit
import GameplayKit

class HealthComponent: GKComponent {
    
    let fullHealth: Int
    var health: Int
    let healthBarFullWidth: CGFloat
    let healthBar: SKShapeNode
    let soundAction = SKAction.playSoundFileNamed("Hit.mp3", waitForCompletion: false)
    
    
    init(parentNode: SKNode, barWidth: CGFloat, barOffset: CGFloat, health: Int) {
        self.fullHealth = health
        self.health = health
        
        healthBarFullWidth = barWidth
        healthBar = SKShapeNode(rectOfSize: CGSizeMake(healthBarFullWidth, 5), cornerRadius: 1)
        healthBar.fillColor = UIColor.greenColor()
        healthBar.strokeColor = UIColor.greenColor()
        healthBar.position = CGPointMake(0, barOffset)
        parentNode.addChild(healthBar)
        
        healthBar.hidden = true
    }
    
    
    func takeDamage(damage: Int) -> Bool {
        health = max(health - damage, 0)
     
        healthBar.hidden = false
        let healthScale = CGFloat(health)/CGFloat(fullHealth)
        let scaleAction = SKAction.scaleXTo(healthScale, duration: 0.5)
        healthBar.runAction(SKAction.group([soundAction, scaleAction]))
        return health == 0
    }
}
