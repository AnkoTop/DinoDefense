//
//  GameScene.swift
//  DinoDefense
//
//  Inital version created by Toby Stephens on 26/09/2015.
//  Copyright © 2015 razeware. All rights reserved.
//
//  Additions by Anko Top
//  Copyright © 2016 REactivity. All rights reserved.

import SpriteKit
import GameplayKit


class GameScene: GameSceneHelper {
  
  // A GameScene state machine
  lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
    GameSceneReadyState(scene: self),
    GameSceneActiveState(scene: self),
    GameSceneWinState(scene: self),
    GameSceneLoseState(scene: self)
    ])
  
  // Update timing information
  var lastUpdateTimeInterval: NSTimeInterval = 0
  
  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    // Set the initial GameScene state
    stateMachine.enterState(GameSceneReadyState.self)
  }
  
  // Update per frame
  override func update(currentTime: NSTimeInterval) {
    super.update(currentTime)
    
    // No updates to perform if this scene isn't being rendered
    guard view != nil else { return }
    
    // Calculate the amount of time since update was last called
    let deltaTime = currentTime - lastUpdateTimeInterval
    lastUpdateTimeInterval = currentTime
    
    // Don't evaluate any updates if the scene is paused.
    if paused { return }
    
    // Update the level's state machine.
    stateMachine.updateWithDeltaTime(deltaTime)
  }
  
  override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
    guard let touch = touches.first else {
      return
    }
    print("Touch: \(touch.locationInNode(self))")

    if let _ = stateMachine.currentState as? GameSceneReadyState {
      stateMachine.enterState(GameSceneActiveState.self)
      return
    }
  }
  
  func startFirstWave() {
    print("Start first wave!")
  }
  
}


