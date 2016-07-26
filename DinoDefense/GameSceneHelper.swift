//
//  GameSceneHelper.swift
//  VillageDefense
//
//  Initial version created by Toby Stephens on 26/09/2015.
//  Copyright © 2015 razeware. All rights reserved.
//
//  Additions by Anko Top
//  Copyright © 2016 REactivity. All rights reserved.

import SpriteKit
import GameKit
import AVFoundation

// The names and zPositions of all the key layers in the GameScene
enum GameLayer: CGFloat {
  // The difference in zPosition between all the dinosaurs, towers and obstacles
  static let zDeltaForSprites: CGFloat = 10
  
  // The zPositions of all the GameScene layers
  case Background = -100
  case Shadows = -50
  case Sprites = 0
  case Hud = 1000
  case Overlay = 1100
  
  // The name the layers in the GameScene scene file
  var nodeName: String {
    switch self {
    case .Background: return "Background"
    case .Shadows: return "Shadows"
    case .Sprites: return "Sprites"
    case .Hud: return "Hud"
    case .Overlay: return "Overlay"
    }
  }
  
  // All layers
  static var allLayers = [Background, Shadows, Sprites, Hud, Overlay]
}


class GameSceneHelper: SKScene  {
  
  // All the GameScene layer nodes
  var gameLayerNodes = [GameLayer: SKNode]()
  
  // Used when placing dinosaurs
  let random = GKRandomDistribution.d20()
  
  // View size and scale
  var viewSize: CGSize {
    return self.view!.frame.size
  }
  var sceneScale: CGFloat {
    let minScale = min(viewSize.width / self.size.width, viewSize.height / self.size.height)
    let maxScale = max(viewSize.width / self.size.width, viewSize.height / self.size.height)
    return sqrt(minScale / maxScale)
  }
  
  // HUD
  var baseLabel: SKLabelNode!
  var waveLabel: SKLabelNode!
  var goldLabel: SKLabelNode!
  
  // Nodes used for the screens for the different game states
  var readyScreen: ReadyNode!
  var winScreen: WinNode!
  var loseScreen: LoseNode!

  // Base lives
  var baseLives = 5
  
  // Gold
  var gold = 75
  
  // Background music
  var musicPlayer: AVAudioPlayer!

  // Sound effects
  let baseDamageSoundAction = SKAction.playSoundFileNamed("LifeLost.mp3", waitForCompletion: false)
  let winSoundAction = SKAction.playSoundFileNamed("YouWin.mp3", waitForCompletion: false)
  let loseSoundAction = SKAction.playSoundFileNamed("YouLose.mp3", waitForCompletion: false)
  

  override func didMoveToView(view: SKView) {
    super.didMoveToView(view)
    
    // No need for gravity
    physicsWorld.gravity = CGVector.zero

    // Load the game layers
    loadGameLayers()
    
    // Layout the HUD elements so that they are in the correct position for the screen size
    layoutHUD()
    
    // Load screens for Ready, Win and Lose states
    loadStateScreens()
    
    // Ready
    showReady(true)    
  }
  
  func startBackgroundMusic() {
    // Start the background music
    let musicFileURL = NSBundle.mainBundle().URLForResource("BackgroundMusic", withExtension: "mp3")
    do {
      musicPlayer = try  AVAudioPlayer(contentsOfURL: musicFileURL!)
      musicPlayer.prepareToPlay()
      musicPlayer.volume = 0.5
      musicPlayer.numberOfLoops = -1
      musicPlayer.play()
    }
    catch {
      fatalError ("Error loading \(musicFileURL): \(error)")
    }
  }
  
  // Load the Game layers
  func loadGameLayers() {
    for gameLayer in GameLayer.allLayers {
      // Find the node in the scene file
      let foundNodes = self[gameLayer.nodeName]
      let layerNode = foundNodes.first!
      
      // Set the zPosition - should be the same as the scene file, but worth setting
      layerNode.zPosition = gameLayer.rawValue
      
      // Store Game layer node
      gameLayerNodes[gameLayer] = layerNode
    }
  }
  
  // Layout the HUD elements to fit the screen
  func layoutHUD() {
    let hudNode = gameLayerNodes[.Hud]!
    
    // Position Base Health label
    baseLabel = hudNode.childNodeWithName("BaseLabel") as! SKLabelNode
    baseLabel.position = CGPointMake(baseLabel.position.x, (self.size.height - baseLabel.position.y) * sceneScale)
    baseLabel.alpha = 0
    
    // Position Wave label
    waveLabel = hudNode.childNodeWithName("WaveLabel") as! SKLabelNode
    waveLabel.position = CGPointMake(waveLabel.position.x, (self.size.height - waveLabel.position.y) * sceneScale)
    waveLabel.alpha = 0
    
    // Position Gold label
    goldLabel = hudNode.childNodeWithName("GoldLabel") as! SKLabelNode
    goldLabel.position = CGPointMake(goldLabel.position.x, (self.size.height - goldLabel.position.y) * sceneScale)
    goldLabel.alpha = 0
  }
  
  // Update the hud labels
  func updateHUD() {
    baseLabel.text = "Lives: \(max(0, baseLives))"
    goldLabel.text = "Gold: \(gold)"
  }
  
  // Load the screens for the Ready, Win and Lose states from their SKS files
  func loadStateScreens() {
    // Ready
    let readyScenePath: String = NSBundle.mainBundle().pathForResource("ReadyScene", ofType: "sks")!
    let readyScene = NSKeyedUnarchiver.unarchiveObjectWithFile(readyScenePath) as! SKScene
    readyScreen = (readyScene.childNodeWithName("MainNode"))!.copy() as! ReadyNode
    
    // Win
    let winScenePath: String = NSBundle.mainBundle().pathForResource("WinScene", ofType: "sks")!
    let winScene = NSKeyedUnarchiver.unarchiveObjectWithFile(winScenePath) as! SKScene
    winScreen = (winScene.childNodeWithName("MainNode"))!.copy() as! WinNode
    
    // Lose
    let loseScenePath: String = NSBundle.mainBundle().pathForResource("LoseScene", ofType: "sks")!
    let loseScene = NSKeyedUnarchiver.unarchiveObjectWithFile(loseScenePath) as! SKScene
    loseScreen = (loseScene.childNodeWithName("MainNode"))!.copy() as! LoseNode
  }
    
  // Show the state screens
  func showReady(show: Bool) {
    if show {
      updateHUD()
      addNode(readyScreen, toGameLayer: .Overlay)
      readyScreen.show()
    }
    else {
      readyScreen.hide()
    }
  }
  func showWin() {
    // Play the end music
    self.runAction(winSoundAction)
    
    // Stop the background music
    musicPlayer.pause()
    
    // Show the win screen
    winScreen.alpha = 0.0
    addNode(winScreen, toGameLayer: .Overlay)
    winScreen.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1.0, duration: 1.0),SKAction.runBlock({ () -> Void in
      // Pause the scene
      self.speed = 0.1
    })]))
    winScreen.show()
  }
  func showLose() {
    // Play the end music
    self.runAction(loseSoundAction)
    
    // Stop the background music
    musicPlayer.pause()
    
    // Show the lose screen
    loseScreen.alpha = 0.0
    addNode(loseScreen, toGameLayer: .Overlay)
    loseScreen.runAction(SKAction.sequence([SKAction.fadeAlphaTo(1.0, duration: 1.0),SKAction.runBlock({ () -> Void in
      // Pause the scene
      self.speed = 0.1
    })]))
    loseScreen.show()
  }

  func addNode(node: SKNode, toGameLayer: GameLayer) {
    gameLayerNodes[toGameLayer]!.addChild(node)
  }
}
