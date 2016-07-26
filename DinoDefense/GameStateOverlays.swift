//
//  GameStateOverlays.swift
//  VillageDefense
//
//  Initial version reated by Toby Stephens on 08/09/2015.
//  Copyright © 2015 razeware. All rights reserved.
//
//  Additions by Anko Top
//  Copyright © 2016 REactivity. All rights reserved.

import Foundation
import SpriteKit


class ReadyNode: SKNode {

  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  var tapLabel: SKLabelNode {
    return self.childNodeWithName("TapLabel") as! SKLabelNode
  }
  
  func show() {
    tapLabel.setScale(0.1)
    
    let actionZoomIn = SKAction.scaleTo(1.0, duration: 1.0)
    actionZoomIn.timingMode = .EaseIn
    let actionPulseIn = SKAction.scaleTo(1.05, duration: 0.2)
    let actionPulseOut = SKAction.scaleTo(0.95, duration: 0.2)
    let actionPulse = SKAction.sequence([actionPulseIn, actionPulseOut])
    let action = SKAction.sequence([actionZoomIn, SKAction.repeatActionForever(actionPulse)])
    tapLabel.runAction(action)
  }
  
  func hide() {
    let actionZoomOut = SKAction.scaleTo(0.1, duration: 1.0)
    actionZoomOut.timingMode = .EaseOut
    tapLabel.runAction(actionZoomOut)
    
    let actionFadeOut = SKAction.fadeAlphaTo(0.0, duration: 1.0)
    let actionPop = SKAction.runBlock { () -> Void in
      self.removeFromParent()
    }
    let action = SKAction.sequence([actionFadeOut, actionPop])
    self.runAction(action)
  }
  
}


class WinNode: SKNode {

  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func show() {
  }
  
}


class LoseNode: SKNode {
  
  override init() {
    super.init()
  }
  
  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  func show() {
  }
  
}

