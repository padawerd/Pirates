//
//  GameScene.swift
//  Pirates
//
//  Created by david padawer on 3/4/18.
//  Copyright © 2018 DPad Studios. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {

    let cannonBallSpeed : CGFloat = 400

    var players : [SKSpriteNode] = []
    var rotationValues : [CGFloat] = []
    var velocityValues : [CGFloat] = []
    var playerLives : [Int] = []
    let gameOverLabel = SKLabelNode(fontNamed: "BaskervilleOldFace")
    let playAgainButton = ButtonNode(text: "Play Again")
    var restart : (() -> Void)!

    override func didMove(to view: SKView) {
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        self.players.append(childNode(withName: "playerOne") as! SKSpriteNode)
        self.players.append(childNode(withName: "playerTwo") as! SKSpriteNode)
        for _ in players {
            rotationValues.append(0)
            velocityValues.append(0)
            playerLives.append(3)
        }
    }

    override func update(_ currentTime: TimeInterval) {
        for i in 0...(self.players.count - 1) {
            self.players[i].physicsBody?.angularVelocity = rotationValues[i]
            self.players[i].physicsBody?.velocity = calculateVector(angle: self.players[i].zRotation, magnitude: velocityValues[i])
            if let contactedBodies = self.players[i].physicsBody?.allContactedBodies() {
                for body in contactedBodies  {
                    if body.node?.name == "cannonBall" {
                        body.node?.removeFromParent()
                        self.damage(player: i)
                    }
                }
            }
            if let contactedBodies = self.physicsBody?.allContactedBodies() {
                for body in contactedBodies {
                    if body.node?.name == "cannonBall" {
                        body.node?.removeFromParent()
                    }
                }
            }
        }
    }

    func calculateVector(angle: CGFloat, magnitude: CGFloat) -> CGVector {
        let dx = sin(angle) * magnitude
        let dy = -(cos(angle) * magnitude)
        return CGVector(dx: dx, dy: dy)
    }

    func addVectors(_ a: CGVector, _ b: CGVector) -> CGVector {
        return CGVector(dx: a.dx + b.dx, dy: a.dy + b.dy)
    }

    //side: 0 = left, 1 = right
    func shoot(player: Int, side: Int) {
        let currentPlayer = self.players[player]
        let cannonBall = SKSpriteNode(imageNamed: "cannonBall")
        cannonBall.name = "cannonBall"
        let cannonBallPhysicsBody = SKPhysicsBody(circleOfRadius: 5)
        cannonBallPhysicsBody.affectedByGravity = false
        cannonBallPhysicsBody.friction = 0
        cannonBallPhysicsBody.linearDamping = 0
        cannonBallPhysicsBody.angularDamping = 0
        //makes it easier to detect collisions
        cannonBallPhysicsBody.restitution = 0
        var angle : CGFloat
        if side == 0 {
            angle = currentPlayer.zRotation + (CGFloat.pi / 2)
        } else {
            angle = currentPlayer.zRotation - (CGFloat.pi / 2)
        }
        let cannonBallVector = self.addVectors(self.calculateVector(angle: angle, magnitude: self.cannonBallSpeed), currentPlayer.physicsBody!.velocity)
        cannonBallPhysicsBody.velocity = cannonBallVector
        cannonBall.physicsBody = cannonBallPhysicsBody
        cannonBall.position = self.calculateCannonLocation(player: player, angle: angle)
        self.addChild(cannonBall)
    }

    func damage(player: Int) {
        //damage player, then update sprite
        self.playerLives[player] -= 1
        if (self.playerLives[player] == 0) {
            self.players[player].removeFromParent()
            self.gameOverWithWinner(player: player)
            return
        }
        let newTextureName = "player" + String(player + 1) + "Ship" + String(4 - self.playerLives[player])
        self.players[player].texture = SKTexture(imageNamed: newTextureName)
    }

    func gameOverWithWinner(player: Int) {
        self.isPaused = true

        self.gameOverLabel.text = "Player " + String(player + 1) + " Wins!"
        self.gameOverLabel.fontColor = .blue
        self.gameOverLabel.fontSize = 100

        self.playAgainButton.onClick = self.restart
        self.playAgainButton.position = CGPoint(x: -100, y: -150)

        self.addChild(self.playAgainButton)
        self.addChild(self.gameOverLabel)
    }

    //side: 0 = left, 1 = right
    func calculateCannonLocation(player: Int, angle: CGFloat) -> CGPoint {
        let currentPlayerPosition = self.players[player].position
        //half width of boat + half of width of cannonball
        let offset = self.calculateVector(angle: angle, magnitude: (33 + 10) / 2)
        let x = currentPlayerPosition.x + offset.dx
        let y = currentPlayerPosition.y + offset.dy
        return CGPoint(x: x, y: y)
    }


    override func keyDown(with event: NSEvent) {
        if let characters = event.characters {
            switch characters {
                case "a":
                    rotationValues[0] = min(5, rotationValues[0] + 5)
                    break
                case "d":
                    rotationValues[0] = max(-5, rotationValues[0] - 5)
                    break
                case "w":
                    velocityValues[0] = min(100, velocityValues[0] + 100)
                    break
                case "j":
                    rotationValues[1] = min(5, rotationValues[1] + 5)
                    break
                case "l":
                    rotationValues[1] = max(-5, rotationValues[1] - 5)
                    break
                case "i":
                    velocityValues[1] = min(100, velocityValues[0] + 100)
                    break
                case "q":
                    self.shoot(player: 0, side: 0)
                    break
                case "e":
                    self.shoot(player: 0, side: 1)
                    break
                case "u":
                    self.shoot(player: 1, side: 0)
                    break
                case "o":
                    self.shoot(player: 1, side: 1)
                    break
                default:
                    break
            }
        }
    }

    override func keyUp(with event: NSEvent) {
        if let characters = event.characters {
            switch characters {
            case "a":
                rotationValues[0] = max(-5, rotationValues[0] - 5)
                break
            case "d":
                rotationValues[0] = min(5, rotationValues[0] + 5)
                break
            case "w":
                velocityValues[0] = max(0, velocityValues[0] - 100)
                break
            case "j":
                rotationValues[1] = max(-5, rotationValues[1] - 5)
                break
            case "l":
                rotationValues[1] = min(5, rotationValues[1] + 5)
                break
            case "i":
                velocityValues[1] = max(0, velocityValues[1] - 100)
                break
            default:
                break
            }
        }
    }
}
