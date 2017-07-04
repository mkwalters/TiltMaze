//
//  GameScene.swift
//  TiltMaze
//
//  Created by Walters Mitch on 5/31/17.
//  Copyright © 2017 Mitchell Walters. All rights reserved.
//

import SpriteKit
import GameplayKit
import CoreGraphics
import CoreMotion


struct physicsCategory {
    
    static let spaceship: UInt32 = 0x1 << 1
    static let obstacle: UInt32 = 0x1 << 2
    static let missile: UInt32 = 0x1 << 3
    //    static let Ground : UInt32 = 0x1 << 2
    //    static let Wall : UInt32 = 0x1 << 3
}


class GameScene: SKScene {
    
    
    
    let player_block = SKSpriteNode(color: SKColor.white, size: CGSize(width: 100, height: 100 ) )
    
    let motion_manager = CMMotionManager()
    
    
    let x_range = SKRange(lowerLimit: 300, upperLimit: 340)
    let y_range = SKRange(lowerLimit: 100, upperLimit: 500)
    
    
    
    var moles = [SKSpriteNode]()
    
    
    var score = 0
    
    let score_label = SKLabelNode()
    
    
    
    
    func replace_moles() {
        
        
        for mole in moles {
            
            mole.removeFromParent()
            
        }
        moles.removeAll()
        
        let new_mole = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100))
        
        new_mole.position = get_random_point_on_screen()
        
        
        addChild(new_mole)
        moles.append(new_mole)
        
    }
    
    override func didMove(to view: SKView) {
        self.backgroundColor = SKColor.black
        player_block.position = CGPoint(x: 0, y: 0)
        
        
        //player_block.size = CGSize(width: 120, height: 140)
        player_block.position = CGPoint(x: 0, y: -(self.frame.height / 4) - 150)
        player_block.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 100, height: 100 ))
        player_block.physicsBody?.categoryBitMask = physicsCategory.spaceship
        player_block.physicsBody?.collisionBitMask = physicsCategory.obstacle
        player_block.physicsBody?.contactTestBitMask = physicsCategory.obstacle
        player_block.physicsBody?.isDynamic = true
        player_block.physicsBody?.affectedByGravity = false
        player_block.zPosition = 2
        
        
        if motion_manager.isAccelerometerAvailable {
            
            motion_manager.startAccelerometerUpdates()
            motion_manager.accelerometerUpdateInterval = 0.1
            //print(motion_manager.gyroData)
        }
        
        addChild(player_block)
        
        
        let test_mole = SKSpriteNode(color: SKColor.red, size: CGSize(width: 100, height: 100))
        test_mole.position = get_random_point_on_screen()
        moles.append(test_mole)
        addChild(test_mole)
        
        
        let x_range = SKRange(lowerLimit: -1 * self.frame.width / 2 , upperLimit: self.frame.width / 2)
        let y_range = SKRange(lowerLimit: -1 * self.frame.height / 2, upperLimit: self.frame.height / 2)
        
        let x_constraint = SKConstraint.positionX(x_range)
        let y_constraint = SKConstraint.positionY(y_range)
        
        let constraints = [ x_constraint, y_constraint ]
        
        player_block.constraints = constraints
        
        
        score_label.text = String(score)
        score_label.fontColor = SKColor.green
        score_label.fontSize = 100.0
        score_label.zPosition = 20
        
        score_label.position = CGPoint(x: self.frame.width / 2 - 45, y: self.frame.height / 2 - 90 )
        addChild(score_label)
        
        
    }
    
    
    func randomIntFrom(start: Int, to end: Int) -> Int {
        var a = start
        var b = end
        // swap to prevent negative integer crashes
        if a > b {
            swap(&a, &b)
        }
        return Int(arc4random_uniform(UInt32(b - a + 1))) + a
    }
    
    
    
    func get_random_point_on_screen() -> CGPoint {
        
        
        let x = randomIntFrom(start: Int(-self.frame.width / 2), to: Int(self.frame.width / 2))
        let y = randomIntFrom(start: Int(-self.frame.height / 2), to: Int(self.frame.height / 2))
        
        return( CGPoint(x: x, y: y ) )
        
        
    }
    
    func increment_score() {
        
        score += 1
        score_label.text = String(score)
        
    }
    
    func touchDown(atPoint pos : CGPoint) {

    }
    
    func touchMoved(toPoint pos : CGPoint) {

    }
    
    func touchUp(atPoint pos : CGPoint) {

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {

    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        
        let base_acceleration = 3000.0
        
        //get_random_point_on_screen()
        
        if motion_manager.isAccelerometerAvailable {
            player_block.physicsBody?.velocity = CGVector(dx: base_acceleration * (motion_manager.accelerometerData?.acceleration.x)!,
                                                          dy: base_acceleration * (motion_manager.accelerometerData?.acceleration.y)!)
        }
        
        for mole in moles {
            
            
            
            
            if player_block.intersects(mole) {
                
                replace_moles()
                print("intersecting")
                
                increment_score()
                
            }
            
            
        }
        
        
        
    }
}
