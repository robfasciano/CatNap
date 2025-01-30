//
//  GameScene.swift
//  CatNap
//
//  Created by Robert Fasciano on 1/25/25.
//

import SpriteKit

protocol EventListenerNode {
    func didMoveToScene()
}

protocol InteractiveNode {
    func interact()
}

struct PhysicsCategory {
    static let None: UInt32 = 0
    static let Cat: UInt32 = 0b1 // 1
    static let Block: UInt32 = 0b10 // 2
    static let Bed: UInt32 = 0b100 // 4
    static let Edge: UInt32 = 0b1000 // 8
    static let Label: UInt32 = 0b10000 // 16
    static let Spring: UInt32 = 0b100000 // 32
    static let Hook: UInt32 = 0b1000000 // 64
}

class GameScene: SKScene, SKPhysicsContactDelegate {
    var bedNode: BedNode!
    var catNode: CatNode!
    var playable = true
    var currentLevel: Int = 0
    var hookBaseNode: HookBaseNode?
    
    //2
    class func level(levelNum: Int) -> GameScene? {
        let scene = GameScene(fileNamed: "Level\(levelNum)")!
            scene.currentLevel = levelNum
            scene.scaleMode = .aspectFill
            return scene
    }

    override func didMove(to view: SKView) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height
                                       - maxAspectRatioHeight)/2
        let playableRect = CGRect(x: 0, y: playableMargin,
                                  width: size.width, height: size.height-playableMargin*2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        physicsWorld.contactDelegate = self
        physicsBody!.categoryBitMask = PhysicsCategory.Edge
        
        bedNode = childNode(withName: "bed") as? BedNode
        catNode = childNode(withName: "//cat_body") as? CatNode
                
        //adding this is a work around for a frozen animation in scene
        self.isPaused = true
        self.isPaused = false
        enumerateChildNodes(withName: "//*", using: { node, _ in
            if let eventListenerNode = node as? EventListenerNode {
                eventListenerNode.didMoveToScene()
            }
        })
        
        //uncomment out second line for background music
        SKTAudio.sharedInstance()
//            .playBackgroundMusic("backgroundMusic.mp3")

//          example of a rotational constraint on the cat
//        let rotationConstraint = SKConstraint.zRotation(
//        SKRange(lowerLimit: -π/4, upperLimit: π/4))
//        catNode.parent!.constraints = [rotationConstraint]
        
        hookBaseNode = childNode(withName: "hookBase") as? HookBaseNode
        
        guard let fulcrumNode = childNode(withName: "seesawBase") else {return}
        guard let leverNode = childNode(withName: "seesaw") else {return}
        let pinJoint = SKPhysicsJointPin.joint(
            withBodyA: fulcrumNode.physicsBody!,
            bodyB: leverNode.physicsBody!,
            anchor: fulcrumNode.position)
        scene!.physicsWorld.add(pinJoint)
        print("should be pinned")
    }
    
    override func didSimulatePhysics() {
        if playable && hookBaseNode?.isHooked != true {
            if abs(catNode.parent!.zRotation) >
                CGFloat(25).degreesToRadians() {
                lose()
            }
        }
    }
    

    func didBegin(_ contact: SKPhysicsContact) {
        let collision = contact.bodyA.categoryBitMask
        | contact.bodyB.categoryBitMask
        
        if collision == PhysicsCategory.Edge | PhysicsCategory.Label {
            let labelNode = (contact.bodyA.categoryBitMask ==
            PhysicsCategory.Label ? contact.bodyA.node :
            contact.bodyB.node) as? MessageNode
            labelNode?.didBounce()
        }
        
        if !playable {
            return
        }

        if collision == PhysicsCategory.Cat | PhysicsCategory.Bed {
//            print("SUCCESS")
            win()
        } else if collision == PhysicsCategory.Cat
                    | PhysicsCategory.Edge {
//            print("FAIL")
            lose()
        } else if collision == PhysicsCategory.Cat | PhysicsCategory.Hook
                    && hookBaseNode?.isHooked == false {
            hookBaseNode!.hookCat(catPhysicsBody:
                                    catNode.parent!.physicsBody!)
        }
    }
    
    func inGameMessage(text: String) {
        let message = MessageNode(message: text)
        message.position = CGPoint(x: frame.midX, y: frame.midY)
        addChild(message)
    }
    
    func newGame() {
        view!.presentScene(GameScene.level(levelNum: currentLevel))
    }
    
    func lose() {
        playable = false
        //1
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("lose.mp3")
        //2
        inGameMessage(text: "Try again...")
        if currentLevel > 1 {
            currentLevel -= 1
        }
        //3
        run(SKAction.afterDelay(5, runBlock: newGame))
        catNode.wakeUp()
    }
    
    func win() {
        playable = false
        SKTAudio.sharedInstance().pauseBackgroundMusic()
        SKTAudio.sharedInstance().playSoundEffect("win.mp3")
        
        inGameMessage(text: "Nice job!")
        if currentLevel < 4 {
            currentLevel += 1
        }
        
        run(SKAction.afterDelay(5, runBlock: newGame))
        catNode.curlAt(scenePoint: bedNode.position)
    }
    
}
