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
}

class GameScene: SKScene {
    override func didMove(to view: SKView) {
        // Calculate playable margin
        let maxAspectRatio: CGFloat = 16.0/9.0
        let maxAspectRatioHeight = size.width / maxAspectRatio
        let playableMargin: CGFloat = (size.height
                                       - maxAspectRatioHeight)/2
        let playableRect = CGRect(x: 0, y: playableMargin,
                                  width: size.width, height: size.height-playableMargin*2)
        physicsBody = SKPhysicsBody(edgeLoopFrom: playableRect)
        
        var bedNode: BedNode!
        bedNode = childNode(withName: "bed") as? BedNode
        
        var catNode: CatNode!
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
        
//        bedNode.setScale(1.5)
//        catNode.setScale(1.5)
    }
}
