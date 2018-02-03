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
import Firebase
import FirebaseDatabase
import FirebaseCore
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
    
<<<<<<< HEAD
    
    static func getAPlace(name : String) -> Place {
        let dataname = Database.database().reference()
        let place: Place
        
        //print(observeDay)
        dataname.child(name).child("imageURL").observe(.value) {
            (data: DataSnapshot) in
            //print (data)
            place.imageURL = data.value as? String
        }
        dataname.child(name).child("latitude").observe(.value) {
            (data: DataSnapshot) in
            //print (data)
            place.latitude = data.value as? Float
        }
        dataname.child(name).child("longitude").observe(.value) {
            (data: DataSnapshot) in
            //print (data)
            place.longitude = data.value as? Float
        }
        
        return place
    }
    
    static func getPlaces() {
        let dataname = Database.database().reference()
        var places : [Place] = [Place]()
        print (data)
        dataname.observe(.value) {
            (data: DataSnapshot) in
            print(data)
            tempplace = data.value as? String
            places.append(getAPlace(tempplace))
        }
        
    }
    
=======
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
<<<<<<< HEAD
    
    static func calcARAnchors(){
        
    }
=======
>>>>>>> b8f01c87fc1253ac653f02e84f34526f7ae65fd8
>>>>>>> e245d24ac812f2d1674200ad48923230085223ac
}








