//
//  BedNode.swift
//  CatNap
//
//  Created by Robert Fasciano on 1/26/25.
//

import SpriteKit

class BedNode: SKSpriteNode, EventListenerNode {
    func didMoveToScene() {
        print("bed added to scene")
        
        let bedBodySize = CGSize(width: 40.0, height: 30.0)
        physicsBody = SKPhysicsBody(rectangleOf: bedBodySize)
        physicsBody!.isDynamic = false
        physicsBody!.categoryBitMask = PhysicsCategory.Bed
        physicsBody!.collisionBitMask = PhysicsCategory.None
    }
}
