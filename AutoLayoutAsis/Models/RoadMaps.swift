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
    let distance: Distance
    let duration: Duration
    let steps: [Step]
    
    private enum CodingKeys: String, CodingKey {
        case distance
        case duration
        case steps
    }
}

struct Step: Decodable {
    let travelMode: String
    let startLocation: Location
    let endLocation: Location
    let polyline: Polyline
    let distance: Distance
    
    private enum CodingKeys: String, CodingKey {
        case travelMode = "travel_mode"
        case startLocation = "start_location"
        case endLocation = "end_location"
        case polyline
        case distance = "distance"
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

struct Distance: Decodable {
    let text: String
    let value: Int
    
    private enum CodingKeys: String, CodingKey {
        case text
        case value
    }
}

struct Duration: Decodable {
    let text: String
    let value: Int
    
    private enum CodingKeys: String, CodingKey {
        case text
        case value
    }
}

