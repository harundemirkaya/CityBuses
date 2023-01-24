// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let station = try? JSONDecoder().decode(Station.self, from: jsonData)

import Foundation

// MARK: - Station
struct StationResponseModel: Codable {
    let lastUpdated: Int?
    let stops: [Stop]?

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case stops
    }
}

// MARK: - Stop
struct Stop: Codable {
    let stopID: Int?
    let atcoCode, name: String?
    let identifier: String?
    let locality: String?
    let orientation: Int?
    let direction: Direction?
    let latitude, longitude: Double?
    let serviceType: ServiceType?
    let atcoLatitude, atcoLongitude: Double?
    let destinations: [String]?
    let services: [String]?

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case atcoCode = "atco_code"
        case name, identifier, locality, orientation, direction, latitude, longitude
        case serviceType = "service_type"
        case atcoLatitude = "atco_latitude"
        case atcoLongitude = "atco_longitude"
        case destinations, services
    }
}

enum Direction: String, Codable {
    case e = "E"
    case n = "N"
    case ne = "NE"
    case nw = "NW"
    case s = "S"
    case se = "SE"
    case sw = "SW"
    case w = "W"
}

enum ServiceType: String, Codable {
    case bus = "bus"
    case tram = "tram"
}
