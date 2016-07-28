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
    
    var entities = Set<GKEntity>()
    
    
    // A GameScene state machine
    lazy var stateMachine: GKStateMachine = GKStateMachine(states: [
        GameSceneReadyState(scene: self),
        GameSceneActiveState(scene: self),
        GameSceneWinState(scene: self),
        GameSceneLoseState(scene: self)
        ])
    
    lazy var componentSystems: [GKComponentSystem] = {
        let animationSystem = GKComponentSystem(componentClass: AnimationComponent.self)
        let firingSystem = GKComponentSystem(componentClass: FiringComponent.self)
        return [animationSystem, firingSystem]
    }()
    
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
        
        //Update components
        for componentSystem in componentSystems {
            componentSystem.updateWithDeltaTime(deltaTime)
        }
    }
    
    override func didFinishUpdate() {
        let dinosaurs: [DinosaurEntity] = entities.flatMap { entity in
            if let dinosaur = entity as? DinosaurEntity {
                return dinosaur
            }
            return nil
        }
        let towers: [TowerEntity] = entities.flatMap { entity in
            if let tower = entity as? TowerEntity {
                return tower
            }
            return nil
        }
        
        for tower in towers {
            // 1
            let towerType = tower.towerType
            // 2
            var target: DinosaurEntity?
            // 3
            for dinosaur in dinosaurs.filter({
                (dinosaur: DinosaurEntity) -> Bool in
                distanceBetween(tower.spriteComponent.node, nodeB:
                    dinosaur.spriteComponent.node) < towerType.range}) {
                        // 4
                        if let t = target {
                            if dinosaur.spriteComponent.node.position.x >
                                t.spriteComponent.node.position.x {
                                target = dinosaur
                            }
                        } else {
                            target = dinosaur
                        }
            }
            // 5
            tower.firingComponent.currentTarget = target
        }
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
        // Configuring wave
        addDinosaur(.TRex)
        addTower(.Wood)
    }
    
    func addEntity(entity: GKEntity) {
     
        // 1
        entities.insert(entity)
    
        // 2
        if let spriteNode = entity.componentForClass(
            SpriteComponent.self)?.node {
            addNode(spriteNode, toGameLayer: .Sprites)
        
            // TODO: More here!
            // 1
            if let shadowNode = entity.componentForClass(ShadowComponent.self)?.node {
               
                // 2
                addNode(shadowNode, toGameLayer: .Shadows)
                
                // 3
                let xRange = SKRange(constantValue: shadowNode.position.x)
                let yRange = SKRange(constantValue: shadowNode.position.y)
                let constraint = SKConstraint.positionX(xRange, y: yRange)
                constraint.referenceNode = spriteNode
                shadowNode.constraints = [constraint]
            }
       
        }
        
        for componentSystem in self.componentSystems {
            componentSystem.addComponentWithEntity(entity)
        }
    }
    
    
    func addDinosaur(dinosaurType: DinosaurType) {
        // TEMP - Will be removed later
        let startPosition = CGPointMake(-200, 384)
        let endPosition = CGPointMake(1224, 384)
        let dinosaur = DinosaurEntity(dinosaurType: dinosaurType)
        let dinoNode = dinosaur.spriteComponent.node
        dinoNode.position = startPosition
        dinoNode.runAction(SKAction.moveTo(endPosition, duration: 20))
        addEntity(dinosaur)
        // animate walk
        dinosaur.animationComponent.requestedAnimationState = .Walk
    }
    
    func addTower(towerType: TowerType) {
        // TEMP - Will be removed later
        let position = CGPointMake(400, 384)
        let towerEntity = TowerEntity(towerType: towerType)
        towerEntity.spriteComponent.node.position = position
        towerEntity.animationComponent.requestedAnimationState = .Idle
        addEntity(towerEntity)
    }
    
  
}


