//
//  GameScene.swift
//  FinalProject
//
//  Created by Jacob Grant on 4/16/19.
//  Copyright © 2019 Jacob Grant. All rights reserved.
//

import SpriteKit
import CoreMotion

class GameScene: SKScene, UITextFieldDelegate {
    
    var rocket : SKSpriteNode!
    var backGround : SKSpriteNode!
    var objectImages : [String] = ["436AsteroidBlue", "436AsteroidWhite", "436Asteroid", "436EnemyUFO", "436EnemyAlien", "436EnemyAlienBlue"]
    var rocketImages : [String] = ["436SpaceShipBlue", "436SpaceShipDark", "436SpaceShipGreen", "436SpaceShipPurple"]
    var gameOver : SKLabelNode!
    var timer : Timer!
    var scoreLabel : SKLabelNode!
    var spawnDifficulty = SpawnDifficultySettings.easy
    var speedDifficulty = 4.0
    let motion = CMMotionManager()
    var xAcceleration : CGFloat = 0
    var yAcceleration : CGFloat = 0
    var gameOverDetect : Bool = false
    var backgroundMusic : SKAudioNode!
    var rocketAngle: CGFloat = 0
    var rocketPrevAngle: CGFloat = 0
    var userName : String?
    var restartButton : UIButton?
    final var initialOrientation : CGFloat?

    var score = 0 {
        didSet {
            scoreLabel.text = "Score: \(score)"
        }
    }
    
    override func didMove(to view: SKView) {
        setScene()
        backgroundMusicPlayer!.pause()
        motion.accelerometerUpdateInterval = 0.1
        motion.startAccelerometerUpdates(to: OperationQueue.current!) {(data: CMAccelerometerData?, error: Error?) in
            if self.initialOrientation == nil {
                self.initialOrientation = CGFloat((data?.acceleration.y)!)
            }
            if let accelData = data {
                self.xAcceleration = CGFloat(accelData.acceleration.x)*0.55
                self.yAcceleration = (CGFloat(accelData.acceleration.y) - self.initialOrientation!)*0.53
            }
        }
    }
    
    override func didSimulatePhysics() {
        let previousX = rocket.position.x
        let previousY = rocket.position.y
        rocket.position.x += xAcceleration*35
        rocket.position.y += yAcceleration*35
        
        if (rocket.position.x < -rocket.size.width/2) {
            rocket.position = CGPoint(x: frame.width+rocket.size.width/2, y: rocket.position.y)
        } else if (rocket.position.x > frame.width + rocket.size.width/2) {
            rocket.position = CGPoint(x: -rocket.size.width/2, y: rocket.position.y)
        } else if (rocket.position.y < -rocket.size.height/2) {
            rocket.position = CGPoint(x: rocket.position.x, y: frame.height+rocket.size.height/2)
        } else if (rocket.position.y > frame.height + rocket.size.height/2) {
            rocket.position = CGPoint(x: rocket.position.x, y: -rocket.size.height/2)
        }
        let dx = rocket.position.x - previousX
        let dy = rocket.position.y - previousY
        let angle = atan2(dy, dx)
        if (angle - rocketPrevAngle > .pi) {
            rocketAngle += 2 * .pi
        } else if (rocketPrevAngle - angle > .pi) {
            rocketAngle -= 2 * .pi
        }
        rocketPrevAngle = angle
        rocketAngle = angle * 0.08 + rocketAngle * (1 - 0.08)
        rocket.zRotation = rocketAngle - (.pi)/2
        
    }
    
    func setScene() {
        if let musicURL = Bundle.main.url(forResource: "electronic-senses-beyond-jupiter", withExtension: "mp3") {
            backgroundMusic = SKAudioNode(url: musicURL)
            addChild(backgroundMusic)
        }
        
        let difficulty = UserDefaults.standard.integer(forKey: "difficulty")
        switch difficulty {
            case 0:
                spawnDifficulty = SpawnDifficultySettings.easy
            case 1:
                spawnDifficulty = SpawnDifficultySettings.medium
            case 2:
                spawnDifficulty = SpawnDifficultySettings.hard
            default:
                spawnDifficulty = SpawnDifficultySettings.easy
        }
        
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
        
        rocket = SKSpriteNode(imageNamed: rocketImages[UserDefaults.standard.integer(forKey: "shipColor")])
        rocket.size = CGSize(width: frame.size.width/5, height: frame.size.height/13)
        rocket.position = CGPoint(x: frame.midX, y: frame.midY)
        rocket.zPosition = ZPositions.rocket
        rocket.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: rocket.size.width-5, height: rocket.size.height))
        rocket.physicsBody?.categoryBitMask = PhysicsSettings.rocket
        rocket.physicsBody?.isDynamic = true
        rocket.physicsBody?.affectedByGravity = false
        addChild(rocket)
        
        timer = Timer.scheduledTimer(timeInterval: spawnDifficulty, target: self, selector: #selector(spawnObject), userInfo: nil, repeats: true)
        
    }
    
    @objc func spawnObject() {
        let randSpawn = Int(arc4random_uniform(UInt32(objectImages.count)))
        let object = SKSpriteNode(imageNamed: objectImages[randSpawn])
        
        object.size = CGSize(width: 75, height: 45)
        let xPositionSpawn = CGFloat(arc4random_uniform(UInt32(frame.size.width-object.size.width))) + object.size.width/2
        object.position = CGPoint(x: xPositionSpawn, y: frame.maxY-object.size.height/2)
        object.physicsBody = SKPhysicsBody(circleOfRadius: object.size.width/2)
        object.physicsBody?.categoryBitMask = PhysicsSettings.object
        object.physicsBody?.contactTestBitMask = PhysicsSettings.rocket | PhysicsSettings.laser
        object.physicsBody?.collisionBitMask = PhysicsSettings.none
        object.physicsBody?.isDynamic = true
        object.physicsBody?.affectedByGravity = false
        if (randSpawn == 0 || randSpawn == 1 || randSpawn == 2) {
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
        switch score % 10 {
        case 0:
            spawnDifficulty -= 0.1
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
        laser.position = CGPoint(x: rocket.position.x, y: rocket.position.y)
        
        laser.size = CGSize(width: 5, height: 20)
        laser.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: laser.size.width, height: laser.size.height))
        laser.physicsBody?.affectedByGravity = false
        laser.physicsBody?.isDynamic = true
        laser.physicsBody?.categoryBitMask = PhysicsSettings.laser
        laser.physicsBody?.contactTestBitMask = PhysicsSettings.object
        laser.physicsBody?.collisionBitMask = PhysicsSettings.none
        laser.zPosition = ZPositions.laser
        laser.zRotation = rocket.zRotation
        addChild(laser)
        
        let finalY : CGFloat!
        let finalX : CGFloat!
        let currAngle = laser.zRotation
        if (0 <= currAngle && currAngle < .pi/2) {
            finalY = frame.maxY
            finalX = laser.position.x - abs((finalY-laser.position.y)*tan(currAngle))
        } else if (-3*(.pi/2) <= currAngle && currAngle < -1*(.pi)) {
            finalY = frame.minY
            finalX = laser.position.x - abs(laser.position.y*tan(currAngle))
        } else if (-1*(.pi) <= currAngle && currAngle < -1*(.pi)/2) {
            finalY = frame.minY
            finalX = laser.position.x + abs(laser.position.y*tan(currAngle))
        } else {
            finalY = frame.maxY
            finalX = laser.position.x + abs((finalY-laser.position.y)*tan(currAngle))
        }
        
        let laserDuration:TimeInterval = 0.2
        var action = [SKAction]()
        action.append(SKAction.move(to: CGPoint(x: finalX, y: finalY), duration: laserDuration))
        action.append(SKAction.removeFromParent())
        laser.run(SKAction.sequence(action))
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if (gameOverDetect == false) {
            userFireLaser()
        }
    }
    
    func gameOverMethod() {
        timer.invalidate()
        backgroundMusicPlayer!.play()
        removeChildren(in: [backgroundMusic])
        gameOver = SKLabelNode(text: "Game Over! Final Score: \(score)")
        gameOver.fontSize = 25
        gameOver.fontName = "ChalkboardSE-Bold"
        gameOver.position = CGPoint(x: frame.midX, y: frame.midY+20)
        gameOver.zPosition = ZPositions.label
        gameOver.fontColor = UIColor.yellow
        addChild(gameOver)
        
        scoreLabel.text = "Score: \(score)"
        gameOverDetect = true
        
        restartButton!.isHidden = false
        
        let sceneFrame = CGRect(x: frame.midX/2, y: frame.midY/2, width: frame.midX, height: frame.midY)
        let scene = SKScene(size: sceneFrame.size)
        scene.backgroundColor = UIColor.lightGray
        let textFieldFrame = CGRect(x: frame.midX/4, y: frame.midY, width: frame.maxX-frame.midX/2, height: 50)
        let textField = UITextField(frame: textFieldFrame)
        textField.font = UIFont(name: "ChalkboardSE-Bold", size: 20)
        textField.backgroundColor = UIColor.white
        textField.placeholder = "Please Enter Your Name..."
        textField.delegate = self
        view!.addSubview(textField)
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        userName = textField.text
        UserDefaults.standard.set(score, forKey: userName!)
        textField.resignFirstResponder()
        textField.removeFromSuperview()
        let thanksNode = SKLabelNode(text: "Thanks for Playing \(userName!)!")
        thanksNode.fontSize = 25
        thanksNode.fontColor = UIColor.yellow
        thanksNode.fontName = "ChalkboardSE-Bold"
        thanksNode.position = CGPoint(x: frame.midX, y: frame.midY-40)
        thanksNode.zPosition = ZPositions.label
        addChild(thanksNode)
        return true
    }
    
    func laserCollision(laser: SKSpriteNode, object : SKSpriteNode) {
        if (gameOverDetect == false) {
            if (object.zPosition >= ZPositions.alien) {
                score += 3
            } else {
                score += 2
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

