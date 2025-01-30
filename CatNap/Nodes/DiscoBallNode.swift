//
//  DiscoBallNode.swift
//  CatNap
//
//  Created by Robert Fasciano on 1/30/25.
//

import SpriteKit
import AVFoundation
class DiscoBallNode: SKSpriteNode, EventListenerNode,
                     InteractiveNode {
    private var player: AVPlayer!
    private var video: SKVideoNode!
    
    func didMoveToScene() {
        isUserInteractionEnabled = true
        
        let fileUrl = Bundle.main.url(forResource: "discolights-loop",
                                      withExtension: "mov")!
        player = AVPlayer(url: fileUrl)
        video = SKVideoNode(avPlayer: player)
        
        video.size = scene!.size
        video.position = CGPoint(
            x: scene!.frame.midX,
            y: scene!.frame.midY)
        video.zPosition = -1
        scene!.addChild(video)
        video.play()
    }
    
    func interact() {
    }
    
}
