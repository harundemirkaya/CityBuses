//
//  RoadMaps.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 15.02.2023.
//

import Foundation

struct RouteMaps: Decodable {
    let routes: [RouteMap]
    
    private enum CodingKeys: String, CodingKey {
        case routes
    }
}

struct RouteMap: Decodable {
    let summary: String
    let legs: [Leg]
    
    private enum CodingKeys: String, CodingKey {
        case summary
        case legs
    }
}

struct Leg: Decodable {
    let steps: [Step]
    
    private enum CodingKeys: String, CodingKey {
        case steps
    }
}

struct Step: Decodable {
    let travelMode: String
    let startLocation: Location
    let endLocation: Location
    let polyline: Polyline
    
    private enum CodingKeys: String, CodingKey {
        case travelMode = "travel_mode"
        case startLocation = "start_location"
        case endLocation = "end_location"
        case polyline
    }
}

struct Location: Decodable {
    let lat: Double
    let lng: Double
    
    private enum CodingKeys: String, CodingKey {
        case lat
        case lng
    }
}

struct Polyline: Decodable {
    let points: String
    
    private enum CodingKeys: String, CodingKey {
        case points
    }
}
