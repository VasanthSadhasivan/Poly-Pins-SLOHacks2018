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
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet var sceneView: ARSKView!
    
    @IBAction func Housing(_ sender: Any) {
        Helper.filterType = "housing"
        Helper.getPlaces(sceneView: sceneView)
    }
    @IBAction func Food(_ sender: Any) {
        Helper.filterType = "food"
        Helper.getPlaces(sceneView: sceneView)
    }
    @IBAction func Restrooms(_ sender: Any) {
        Helper.filterType = "restrooms"
        Helper.getPlaces(sceneView: sceneView)
    }
    @IBAction func Recreation(_ sender: Any) {
        Helper.filterType = "recreation"
        Helper.getPlaces(sceneView: sceneView)
    }
    @IBAction func Hydration(_ sender: Any) {
        Helper.filterType = "hydration"
        Helper.getPlaces(sceneView: sceneView)
    }
    @IBAction func Buildings(_ sender: Any) {
        Helper.filterType = "building"
        Helper.getPlaces(sceneView: sceneView)
    }
    
    
    
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
        let temp = UIImage(named: (Helper.anchorDicked[anchor.identifier]?.getImageURL())!)
        print(Helper.anchorDicked[anchor.identifier]?.getImageURL())
        let image = Helper.resizeImage(image: temp!, targetSize: CGSize(width: temp!.size.width*7, height: temp!.size.height*7))
        
        let distance = Helper.myLocation?.distance(from: CLLocation(latitude: CLLocationDegrees((Helper.anchorDicked[anchor.identifier]?.getLatitude())!), longitude: CLLocationDegrees((Helper.anchorDicked[anchor.identifier]?.getLongitude())!)))
        
        let spriteNode = CustomNode(texture: SKTexture(image: image), distance: Float(distance!))
        return spriteNode
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if Helper.myLocation == nil{
            Helper.myLocation = locations[0]
            return
        }
        let newLocation = locations[0]
        let currentLocation = Helper.myLocation
        
        let distance = newLocation.distance(from: currentLocation!)
        if distance > 15{
            let configuration = ARWorldTrackingConfiguration()
            configuration.worldAlignment = .gravityAndHeading
            sceneView.session.run(configuration, options: .resetTracking)
            
            Helper.myLocation = newLocation
            Helper.deleteOldAnchors(sceneView: sceneView)
            Helper.calcARAnchors(sceneView: sceneView)
        }
    }
}
