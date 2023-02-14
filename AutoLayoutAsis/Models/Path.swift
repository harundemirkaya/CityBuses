//
//  Path.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 14.02.2023.
//
// MARK: -Import Libaries
import Foundation
import CoreLocation

// MARK: -Path Class
class Path{
    var distance: Double?
    var location: CLLocation?
    
    init(distance: Double? = nil, location: CLLocation? = nil) {
        self.distance = distance
        self.location = location
    }
}
