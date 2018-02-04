//
//  MarkerNode.swift
//  LocationTicketMasterIntegrationProject
//
//  Created by Vasanth Sadhasivan on 8/13/17.
//  Copyright © 2017 Vasanth Sadhasivan. All rights reserved.
//

import Foundation
import SpriteKit

class CustomNode : SKSpriteNode {
    var distance : SKLabelNode?
    
    required init?(coder aDecoder: NSCoder) {

        super.init(coder: aDecoder)
    }
    
    init(texture: SKTexture!, distance : Float) {
        super.init(texture: texture, color: UIColor.clear, size: texture.size())
        self.distance = SKLabelNode(text: String(distance))
        self.distance?.isHidden = true
        self.addChild(self.distance!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.distance?.isHidden = false
    }
}

