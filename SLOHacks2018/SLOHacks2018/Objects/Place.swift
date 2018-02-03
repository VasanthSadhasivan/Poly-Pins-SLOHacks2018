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
    var anchor : ARAnchor
    var imageURL : String
    
    init(name: String, latitude : Double, longitude : Double, anchor : ARAnchor, imageURL : String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.anchor = anchor
        self.imageURL = imageURL
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
    
    func getAnchor() -> ARAnchor {
        return self.anchor
    }
    
    func getImageURL() -> String {
        return self.imageURL
    }
}
