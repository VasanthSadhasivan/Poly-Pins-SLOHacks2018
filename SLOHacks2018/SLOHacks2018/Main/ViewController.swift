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
        Helper.getPlaces(sceneView: sceneView)

    }
    
    func view(_ view: ARSKView, nodeFor anchor: ARAnchor) -> SKNode? {
        // Create and configure a node for the anchor added to the view's session.
        let labelNode = SKLabelNode(text: "🚻")
        labelNode.fontSize = labelNode.fontSize*250
        labelNode.horizontalAlignmentMode = .center
        labelNode.verticalAlignmentMode = .center
        print("here")

        return labelNode;
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if Helper.myLocation == nil{
            Helper.myLocation = locations[0]
            return
        }
        let newLocation = locations[0]
        let currentLocation = Helper.myLocation
        
        let distance = newLocation.distance(from: currentLocation!)
        print(distance)
        if distance > 10{
            let configuration = ARWorldTrackingConfiguration()
            configuration.worldAlignment = .gravityAndHeading
            sceneView.session.run(configuration, options: .resetTracking)
            
            Helper.myLocation = newLocation
            Helper.deleteOldAnchors(sceneView: sceneView)
            Helper.calcARAnchors(sceneView: sceneView)
        }
        
    }
}
