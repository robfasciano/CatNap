//
//  CatNode.swift
//  CatNap
//
//  Created by Robert Fasciano on 1/27/25.
//

import SpriteKit

class CatNode: SKSpriteNode, EventListenerNode {
    func didMoveToScene() {
        print("cat added to scene")
        
        let catBodyTexture = SKTexture(imageNamed: "cat_body_outline")
        parent!.physicsBody = SKPhysicsBody(texture: catBodyTexture,
        size: catBodyTexture.size())
        parent!.physicsBody!.categoryBitMask = PhysicsCategory.Cat
        parent!.physicsBody!.collisionBitMask = PhysicsCategory.Block
    }
}
