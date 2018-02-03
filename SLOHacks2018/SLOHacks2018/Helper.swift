//
//  Helper.swift
//  SLOHacks2018
//
//  Created by Vasanth Sadhasivan on 2/3/18.
//  Copyright © 2018 Vasanth Sadhasivan. All rights reserved.
//

import Foundation
import GLKit
import ARKit
import CoreLocation

class Helper{
    
    static let locationManager : CLLocationManager = CLLocationManager()
    static var myLocation : CLLocation? = nil
    static var places : [Place]? = nil
    
    static func createTransformationMatrix(distance : Float, azimuth : Float, floor : Int) -> matrix_float4x4 {
        let translationMatrix = GLKMatrix4MakeTranslation(0, Float(floor * -10), -1 * distance)
        let rotationMatrix = GLKMatrix4MakeYRotation(GLKMathDegreesToRadians(360-(azimuth)))
        return float4x4((SCNMatrix4FromGLKMatrix4(GLKMatrix4Multiply(rotationMatrix, translationMatrix))))
        //How this could be employed: anchor = ARAnchor(transform: createTransformationMatrix(distance: XXX, azimuth: XXX, floor: XXX))
    }
    
    static func calculateAzimuth(startLocationLatitude : Float, startLocationLongitude : Float, endLocationLatitude : Float, endLocationLongitude : Float) -> Float {
        var azimuth: Float = 0
        let lat1 = GLKMathDegreesToRadians(startLocationLatitude)
        let lon1 = GLKMathDegreesToRadians(startLocationLongitude)
        let lat2 = GLKMathDegreesToRadians(endLocationLatitude)
        let lon2 = GLKMathDegreesToRadians(endLocationLongitude)
        let dLon = lon2 - lon1
        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)
        azimuth = GLKMathRadiansToDegrees(Float(radiansBearing))
        if(azimuth < 0) { azimuth += 360 }
        return azimuth
    }
    
    static func startLocationService(delegate : CLLocationManagerDelegate){
        // For use in foreground
        locationManager.stopUpdatingLocation()
        myLocation = nil
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = delegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    static func sceneViewSetup(delegate : ARSKViewDelegate, sceneView : ARSKView){
        sceneView.delegate = delegate
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene") {
            sceneView.presentScene(scene)
        }
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        
        // Run the view's session
        sceneView.session.run(configuration)
    }
}
