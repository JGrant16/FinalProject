//
//  GameScene.swift
//  FinalProject
//
//  Created by Jacob Grant on 4/16/19.
//  Copyright © 2019 Jacob Grant. All rights reserved.
//

import SpriteKit
import CoreMotion
class GameScene: SKScene {
    
    var rocket : SKSpriteNode!
    var backGround : SKSpriteNode!
    var objectImages : [String] = ["asteroid", "AlienShip"]
    var gameOver : SKLabelNode!
    var timer : Timer!
    var scoreLabel : SKLabelNode!
    var spawnDifficulty = 1.5
    var speedDifficulty = 3.0
    let motion = CMMotionManager()
    var xAcceleration : CGFloat = 0
    var yAcceleration : CGFloat = 0
    var backgroundMusic : SKAudioNode!
    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        setScene()
        motion.accelerometerUpdateInterval = 0.1
        motion.startAccelerometerUpdates(to: OperationQueue.current!) {(data: CMAccelerometerData?, error: Error?) in
            if let accelData = data {
                self.xAcceleration = CGFloat(accelData.acceleration.x)*0.5
                self.yAcceleration = CGFloat(accelData.acceleration.y)
            }
        }
    }
    
    override func didSimulatePhysics() {
        rocket.position.x += xAcceleration*40
        rocket.position.y += yAcceleration*40
        if (rocket.position.x < -rocket.size.width/2) {
            rocket.position = CGPoint(x: frame.width+rocket.size.width/2, y: rocket.position.y)
        } else if (rocket.position.x > frame.width + rocket.size.width/2) {
            rocket.position = CGPoint(x: -rocket.size.width/2, y: rocket.position.y)
        } else if (rocket.position.y < -rocket.size.height/2) {
            rocket.position = CGPoint(x: rocket.position.x, y: frame.height+rocket.size.height/2)
        } else if (rocket.position.y > frame.height + rocket.size.height/2) {
            rocket.position = CGPoint(x: rocket.position.x, y: -rocket.size.height/2)
        }
    }
    
    func setScene() {
        /*
        if let musicURL = Bundle.main.url(forResource: "Light-Years_v001", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        */
        
        physicsWorld.contactDelegate = self
        
        scoreLabel = SKLabelNode(text: "Score: 0")
        scoreLabel.zPosition = ZPositions.label
        scoreLabel.position = CGPoint(x: 70, y: frame.size.height - 60)
        scoreLabel.fontSize = 25
        scoreLabel.fontColor = UIColor.yellow
        scoreLabel.fontName = "ChalkboardSE-Bold"
        addChild(scoreLabel)
        
        backGround = SKSpriteNode(imageNamed: "Harris-Space-wallpaper")
        backGround.size = CGSize(width: frame.size.width, height: frame.size.height)
        backGround.position = CGPoint(x: frame.midX, y: frame.midY)
        backGround.zPosition = ZPositions.backGround
        addChild(backGround)
        
        rocket = SKSpriteNode(imageNamed: "Spaceship-PNG-File")
        rocket.size = CGSize(width: frame.size.width/7, height: frame.size.height/7)
        rocket.position = CGPoint(x: frame.midX, y: frame.midY)
        rocket.zPosition = ZPositions.rocket
        rocket.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rocket.size.width-5, height: rocket.size.height))
        rocket.physicsBody?.categoryBitMask = PhysicsSettings.rocket
        rocket.physicsBody?.isDynamic = false
        addChild(rocket)
        
        timer = Timer.scheduledTimer(timeInterval: spawnDifficulty, target: self, selector: #selector(spawnObject), userInfo: nil, repeats: true)
        
    }
    
    @objc func spawnObject() {
        let randSpawn = Int(arc4random_uniform(UInt32(2)))
        let object = SKSpriteNode(imageNamed: objectImages[randSpawn])
        
        object.size = CGSize(width: 40, height: 40)
        let xPositionSpawn = CGFloat(arc4random_uniform(UInt32(frame.size.width-object.size.width))) + object.size.width/2
        object.position = CGPoint(x: xPositionSpawn, y: frame.maxY-object.size.height/2)
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width/2)
        object.physicsBody?.categoryBitMask = PhysicsSettings.object
        object.physicsBody?.contactTestBitMask = PhysicsSettings.rocket | PhysicsSettings.laser
        object.physicsBody?.collisionBitMask = PhysicsSettings.none
        object.physicsBody?.isDynamic = true
        object.physicsBody?.affectedByGravity = false
        if (randSpawn == 0) {
            object.zPosition = ZPositions.asteroid
        } else {
            object.zPosition = ZPositions.alien
            objectFireLaser(alien: object)
        }
        addChild(object)
        let objectDuration:TimeInterval = speedDifficulty
        var action = [SKAction]()
        action.append(SKAction.move(to: CGPoint(x: xPositionSpawn, y: frame.minY), duration: objectDuration))
        action.append(SKAction.removeFromParent())
        object.run(SKAction.sequence(action))
        
    }
    
    func difficultyIncrease() {
        switch score {
        case 1,5,10,20,30:
            spawnDifficulty -= 0.05
            timer.invalidate()
            print(spawnDifficulty)
            timer = Timer.scheduledTimer(timeInterval: spawnDifficulty, target: self, selector: #selector(spawnObject), userInfo: nil, repeats: true)
        default:
            break
        }
    }
    
    func objectFireLaser(alien : SKSpriteNode) {
        run(SKAction.playSoundFileNamed("Laser.mp3", waitForCompletion: false))
        let laser = SKSpriteNode(imageNamed: "AlienLaser")
        laser.size = CGSize(width: 10, height: 10)
        laser.position = CGPoint(x: alien.position.x, y: alien.position.y-5)
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: laser.size.width, height: laser.size.height))
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsSettings.alienLaser
        laser.physicsBody?.contactTestBitMask = PhysicsSettings.rocket
        laser.physicsBody?.collisionBitMask = PhysicsSettings.none
        laser.zPosition = ZPositions.laser
        addChild(laser)
        
        let laserDuration:TimeInterval = 1.0
        var action = [SKAction]()
        action.append(SKAction.move(to: CGPoint(x: alien.position.x, y: frame.minY), duration: laserDuration))
        action.append(SKAction.removeFromParent())
        laser.run(SKAction.sequence(action))
    }
    
    func userFireLaser() {
        run(SKAction.playSoundFileNamed("Laser.mp3", waitForCompletion: false))
        let laser = SKSpriteNode(imageNamed: "LaserImage")
        laser.position = CGPoint(x: rocket.position.x, y: rocket.position.y + 5)
        laser.size = CGSize(width: 5, height: 20)
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: laser.size.width, height: laser.size.height))
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsSettings.laser
        laser.physicsBody?.contactTestBitMask = PhysicsSettings.object
        laser.physicsBody?.collisionBitMask = PhysicsSettings.none
        laser.zPosition = ZPositions.laser
        addChild(laser)
        
        let laserDuration:TimeInterval = 0.2
        var action = [SKAction]()
        action.append(SKAction.move(to: CGPoint(x: laser.position.x, y: frame.size.height), duration: laserDuration))
        action.append(SKAction.removeFromParent())
        laser.run(SKAction.sequence(action))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        userFireLaser()
    }
    
    func gameOverMethod() {
        timer.invalidate()
        gameOver = SKLabelNode(text: "Game Over! Final Score: \(score)")
        gameOver.fontSize = 25
        gameOver.fontName = "ChalkboardSE-Bold"
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY)
        gameOver.zPosition = ZPositions.label
        addChild(gameOver)
    }
    
    func laserCollision(laser: SKSpriteNode, object : SKSpriteNode) {
        if (object.zPosition >= ZPositions.alien) {
            score += 2
        } else {
            score += 1
        }
        let explode = SKEmitterNode(fileNamed: "Fire")!
        explode.position = object.position
        addChild(explode)
        run(SKAction.playSoundFileNamed("Explosion.mp3", waitForCompletion: false))
        
        run(SKAction.wait(forDuration: 0.5)) {
            explode.removeFromParent()
        }
        
        removeChildren(in: [laser, object])
        
        difficultyIncrease()
    }
    
    func rocketCollision(rocket: SKSpriteNode, object : SKSpriteNode) {
        let explode = SKEmitterNode(fileNamed: "Fire")!
        explode.position = rocket.position
        addChild(explode)
        run(SKAction.playSoundFileNamed("Explosion.mp3", waitForCompletion: false))
        
        run(SKAction.wait(forDuration: 0.5)) {
            explode.removeFromParent()
        }
        
        removeChildren(in: [rocket, object])
    }
}

extension GameScene : SKPhysicsContactDelegate {
    
    func didBegin(_ contact: SKPhysicsContact) {
        let contactBitMask = contact.bodyA.categoryBitMask | contact.bodyB.categoryBitMask
        
        switch contactBitMask {
        case PhysicsSettings.rocket | PhysicsSettings.object:
            if (contact.bodyA.categoryBitMask == PhysicsSettings.rocket) {
                rocketCollision(rocket: contact.bodyA.node as! SKSpriteNode, object: contact.bodyB.node as! SKSpriteNode)
            } else {
                rocketCollision(rocket: contact.bodyB.node as! SKSpriteNode, object: contact.bodyA.node as! SKSpriteNode)
            }
            gameOverMethod()
        case PhysicsSettings.laser | PhysicsSettings.object:
            if (contact.bodyA.categoryBitMask == PhysicsSettings.laser) {
                laserCollision(laser: contact.bodyA.node as! SKSpriteNode, object: contact.bodyB.node as! SKSpriteNode)
            } else {
                   laserCollision(laser: contact.bodyB.node as! SKSpriteNode, object: contact.bodyA.node as! SKSpriteNode)
            }
        case PhysicsSettings.alienLaser | PhysicsSettings.rocket:
            if (contact.bodyA.categoryBitMask == PhysicsSettings.rocket) {
                rocketCollision(rocket: contact.bodyA.node as! SKSpriteNode, object: contact.bodyB.node as! SKSpriteNode)
            } else {
                rocketCollision(rocket: contact.bodyB.node as! SKSpriteNode, object: contact.bodyA.node as! SKSpriteNode)
            }
            gameOverMethod()
        default:
            print("Some Unknown Collison Happened")
        }
    }
}


