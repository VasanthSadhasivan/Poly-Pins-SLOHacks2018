//
//  Helper.swift
//  SLOHacks2018
//
//  Created by Vasanth, Hunter, Finn, Angello on 2/3/18.
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
    static var places : [Place]? = [Place]()
    static var databaseReference : DatabaseReference!
    static var anchorDicked = [UUID : Place]()
    static var donePullingFBData = false
    static var filterType : String? = nil
    
    static func createTransformationMatrix(distance : Float, azimuth : Float, floor : Int) -> matrix_float4x4
    {
        let translationMatrix = GLKMatrix4MakeTranslation(0, Float(floor * -10), -1 * distance)
        let rotationMatrix = GLKMatrix4MakeYRotation(GLKMathDegreesToRadians(360-(azimuth)))
        return float4x4((SCNMatrix4FromGLKMatrix4(GLKMatrix4Multiply(rotationMatrix, translationMatrix))))
        //How this could be employed: anchor = ARAnchor(transform: createTransformationMatrix(distance: XXX, azimuth: XXX, floor: XXX))
    }
    
    static func calculateAzimuth(startLocationLatitude : Float, startLocationLongitude : Float, endLocationLatitude : Float, endLocationLongitude : Float) -> Float
    {
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
    
    static func startLocationService(delegate : CLLocationManagerDelegate)
    {
        // For use in foreground
        locationManager.stopUpdatingLocation()
        myLocation = nil
        locationManager.requestWhenInUseAuthorization()
        if CLLocationManager.locationServicesEnabled()
        {
            locationManager.delegate = delegate
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    static func getPlaces(sceneView : ARSKView) {
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        sceneView.session.run(configuration, options: .resetTracking)
        
        deleteOldAnchors(sceneView: sceneView)
        places?.removeAll()
        anchorDicked.removeAll()
        donePullingFBData = false
        
        databaseReference = Database.database().reference()
        
        databaseReference.observeSingleEvent(of: .value, with: { (data) in

            for child in data.children.allObjects{
                
                let name : String = ((child as! DataSnapshot).key) as String
                let imageURL : String = (((child as! DataSnapshot).children.allObjects[0] as! DataSnapshot).value) as! String
                let latitude : Float = (((child as! DataSnapshot).children.allObjects[1] as! DataSnapshot).value) as! Float
                let longitude : Float = (((child as! DataSnapshot).children.allObjects[2] as! DataSnapshot).value) as! Float
                let type : String = (((child as! DataSnapshot).children.allObjects[3] as! DataSnapshot).value) as! String
                
                if filterType == nil{
                    places?.append(Place(name: name, latitude: Double(latitude), longitude: Double(longitude), anchor: nil, imageURL: imageURL, type: type))
                }
                
                else{
                    if type == filterType{
                        places?.append(Place(name: name, latitude: Double(latitude), longitude: Double(longitude), anchor: nil, imageURL: imageURL, type: type))
                    }
                }
            }
            
            donePullingFBData = true
            calcARAnchors(sceneView: sceneView)
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }
    
    static func sceneViewSetup(delegate : ARSKViewDelegate, sceneView : ARSKView){
        sceneView.delegate = delegate
        sceneView.showsFPS = true
        sceneView.showsNodeCount = true
        
        // Load the SKScene from 'Scene.sks'
        if let scene = SKScene(fileNamed: "Scene")
        {
            sceneView.presentScene(scene)
        }
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()
        configuration.worldAlignment = .gravityAndHeading
        
        // Run the view's session
        sceneView.session.run(configuration)
    }

    static func calcARAnchors(sceneView : ARSKView){
        DispatchQueue.global(qos: .background).async {
            while !donePullingFBData{
            }
            
            for place : Place in places!{
                let azimuth = calculateAzimuth(startLocationLatitude: Float((myLocation?.coordinate.latitude)!), startLocationLongitude: Float((myLocation?.coordinate.longitude)!), endLocationLatitude: Float(place.getLatitude()), endLocationLongitude:  Float(place.getLongitude()))
            

                let distance = CLLocation(latitude: CLLocationDegrees(Float((myLocation?.coordinate.latitude)!)), longitude: CLLocationDegrees(Float((myLocation?.coordinate.longitude)!))).distance(from: CLLocation(latitude: CLLocationDegrees(place.getLatitude()), longitude: CLLocationDegrees(place.getLongitude())))
                if distance >= 20{
                    place.setAnchor(anchor: ARAnchor(transform: createTransformationMatrix(distance: Float(20), azimuth: azimuth, floor: 0)))
                }else{
                    place.setAnchor(anchor: ARAnchor(transform: createTransformationMatrix(distance: Float(distance), azimuth: azimuth, floor: 0)))
                }
                

                
            }
            initAnchorDicked()
            placeAnchorObjects(sceneView: sceneView)
        }
    }

    static func initAnchorDicked()
    {
        print(places)
        for place : Place in places!
        {
            let anchorID = place.getAnchor()?.identifier
            print("Name: ", place.getName(), anchorID!)
            anchorDicked.updateValue(place, forKey: anchorID!)
        }
    }
    
    static func placeAnchorObjects(sceneView : ARSKView)
    {
        for place in places!
        {
            sceneView.session.add(anchor : place.getAnchor()!)
        }
    }
    
    static func deleteOldAnchors(sceneView : ARSKView){
        for place : Place in places!{
            if place.getAnchor() != nil{
                sceneView.session.remove(anchor: place.getAnchor()!)
            }
        }
    }
    
    static func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        // Figure out what our orientation is, and use that to form the rectangle
        var newSize: CGSize
        if(widthRatio > heightRatio) {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        
        // This is the rect that we've calculated out and this is what is actually used below
        let rect = CGRect(x:0, y:0, width:newSize.width, height:newSize.height)
        
        // Actually do the resizing to the rect using the ImageContext stuff
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
}








