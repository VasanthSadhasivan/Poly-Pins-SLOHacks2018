//
//  Place.swift
//  SLOHacks2018
//
//  Created by Vasanth Sadhasivan on 2/3/18.
//  Copyright © 2018 Vasanth Sadhasivan. All rights reserved.
//

import Foundation
import ARKit

class Place{
    var name : String
    var latitude : Double
    var longitude : Double
    var anchor : ARAnchor?
    var imageURL : String
    var type : String
    
    init(name: String, latitude : Double, longitude : Double, anchor : ARAnchor?, imageURL : String, type: String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.anchor = anchor
        self.imageURL = imageURL
        self.type = type
    }
    
    func getName() -> String {
        return self.name
    }
    
    func getLatitude() -> Double {
        return self.latitude
    }
    
    func getLongitude() -> Double {
        return self.longitude
    }
    
    func getAnchor() -> ARAnchor? {
        return self.anchor
    }
    
    func getImageURL() -> String {
        return self.imageURL
    }
    
    func getType() -> String {
        return self.type
    }
    
    func setName(name : String) {
        self.name = name
    }
    
    func setLatitude(latitude : Double) {
        self.latitude = latitude
    }
    
    func setLongitude(longitude : Double) {
        self.longitude = longitude
    }
    
    func setAnchor(anchor : ARAnchor) {
        self.anchor = anchor
    }
    
    func setImageURL(imageURL: String){
        self.imageURL = imageURL
    }
    
    func setType(type: String){
        self.type = type
    }
}
