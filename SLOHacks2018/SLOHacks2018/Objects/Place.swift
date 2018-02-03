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
    var name : String = ""
    var latitude : Double = 0.0
    var longitude : Double = 0.0
    var anchor : ARAnchor = nil
    var imageURL : String = ""
    
    init(name: String, latitude : Double, longitude : Double, anchor : ARAnchor, imageURL : String) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.anchor = anchor
        self.imageURL = imageURL
    }
}
