//
//  ViewController.swift
//  SLOHacks2018
//
//  Created by Vasanth Sadhasivan on 2/3/18.
//  Copyright © 2018 Vasanth Sadhasivan. All rights reserved.
//

import UIKit
import SpriteKit
import ARKit
import Firebase
import CoreLocation

class ViewController: UIViewController, ARSKViewDelegate, CLLocationManagerDelegate {
    
    @IBOutlet var sceneView: ARSKView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Helper.startLocationService(delegate: self as CLLocationManagerDelegate)
        Helper.sceneViewSetup(delegate: self as ARSKViewDelegate, sceneView: sceneView)
        DispatchQueue.global(qos: .background).async {
            Helper.calcARAnchors()
        }
        Helper.getPlaces()

    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let labelNode = SKLabelNode(text: "👾")
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center

        return labelNode;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Helper.myLocation = locations[0]
    }
}
