//
//  MarkerNode.swift
//  LocationTicketMasterIntegrationProject
//
//  Created by Vasanth, Hunter, Finn, Angello  on 8/13/17.
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
        self.distance = SKLabelNode(text: String(Int(distance)) + " m")
        self.distance?.zPosition = 2
        var labelPos = self.position
        labelPos.y = CGFloat(Int(labelPos.y)+700)
        self.distance?.position = labelPos
        self.isUserInteractionEnabled = true
        self.zPosition = 1
        self.addChild(self.distance!)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.distance?.fontSize = 300
        self.distance?.fontColor = UIColor.white
        self.distance?.fontName = "ArialRoundedMTBold"
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.distance?.fontSize = 0
    }
}

