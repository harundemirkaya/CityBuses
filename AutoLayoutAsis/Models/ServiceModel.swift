// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let serviceModel = try? JSONDecoder().decode(ServiceModel.self, from: jsonData)

import Foundation

// MARK: - ServiceModel
struct ServiceModel: Codable {
    let lastUpdated: Int?
    let services: [Service]?

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case services
    }
}

// MARK: - Service
struct Service: Codable {
    let name, description: String?
    let serviceType: ServiceType2?
    let routes: [Route]?

    enum CodingKeys: String, CodingKey {
        case name, description
        case serviceType = "service_type"
        case routes
    }
}

// MARK: - Route
struct Route: Codable {
    let destination: String?
    let points: [Point]?
    let stops: [String]?
}

// MARK: - Point
struct Point: Codable {
    let stopID: String?
    let latitude, longitude: String?

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case latitude, longitude
    }
}

enum ServiceType2: String, Codable {
    case airport = "airport"
    case country = "country"
    case eastcoast = "eastcoast"
    case lothian = "lothian"
    case nightbus = "nightbus"
    case tram = "tram"
}
