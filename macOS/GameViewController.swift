//
//  GameViewController.swift
//  macOS
//
//  Created by david padawer on 3/4/18.
//  Copyright © 2018 DPad Studios. All rights reserved.
//

import Cocoa
import SpriteKit
import GameplayKit

class GameViewController: NSViewController {

    //var restart : (() -> Void)!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let scene = GameScene(fileNamed: "GameScene")!
        scene.scaleMode = .aspectFit
        
        // Present the scene
        let skView = self.view as! SKView
        skView.presentScene(scene)
        
        skView.ignoresSiblingOrder = true
        
        skView.showsFPS = true
        skView.showsNodeCount = true

        scene.restart = self.restart
    }

    func restart() {
        let skView = self.view as! SKView
        skView.presentScene(nil)
        let newScene = GameScene(fileNamed: "GameScene")!
        newScene.scaleMode = .aspectFit
        newScene.restart = self.restart
        skView.presentScene(newScene)
    }

}

