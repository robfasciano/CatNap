//
//  CatNode.swift
//  CatNap
//
//  Created by Robert Fasciano on 1/27/25.
//

import SpriteKit

class CatNode: SKSpriteNode, EventListenerNode, InteractiveNode {
    static let kCatTappedNotification = "kCatTappedNotification"
    
    func didMoveToScene() {
        print("cat added to scene")
        
        let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
        parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture,
        size: catBodyTexture.size())
        parent!.physicsBody!.categoryBitMask = PhysicsCategory.Cat
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block | PhysicsCategory.Edge | PhysicsCategory.Spring
        parent!.physicsBody!.contactTestBitMask = PhysicsCategory.Bed | PhysicsCategory.Edge
        
        isUserInteractionEnabled = true
    }
    
    func interact() {
        NotificationCenter.default.post(Notification(
            name:NSNotification.Name(CatNode.kCatTappedNotification),
            object: nil))
    }
    
    override func touchesEnded(
        _ touches: Set<UITouch>,
        with event: UIEvent?) {
            super.touchesEnded(touches, with: event)
            interact()
        }
    
    func wakeUp() {
        // 1
        for child in children {
            child.removeFromParent()
        }
        texture = nil
        color = SKColor.clear
        // 2
        let catAwake = SKSpriteNode(
            fileNamed: "CatWakeUp")!.childNode(withName: "cat_awake")!
        // 3
        catAwake.move(toParent: self)
        catAwake.position = CGPoint(x: -30, y: 100)
    }
    
    func curlAt(scenePoint: CGPoint) {
        parent!.physicsBody = nil
        for child in children {
            child.removeFromParent()
        }
        texture = nil
        color = SKColor.clear
        let catCurl = SKSpriteNode(
            fileNamed: "CatCurl")!.childNode(withName: "cat_curl")!
        catCurl.move(toParent: self)
        catCurl.position = CGPoint(x: -30, y: 100)
        var localPoint = parent!.convert(scenePoint, from: scene!)
        localPoint.y += frame.size.height/3
        
        run(SKAction.group([
            SKAction.move(to: localPoint, duration: 0.66),
            SKAction.rotate(toAngle: -parent!.zRotation, duration: 0.5)
        ]))
        //adding this is a work around for a frozen animation in scene
        self.isPaused = true
        self.isPaused = false
    }
    
}
