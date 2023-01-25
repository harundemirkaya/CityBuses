// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let vehicleModel = try? JSONDecoder().decode(VehicleModel.self, from: jsonData)

import Foundation

// MARK: - VehicleModel
struct VehicleModel: Codable {
    let lastUpdated: Int?
    let vehicles: [Vehicle]?

    enum CodingKeys: String, CodingKey {
        case lastUpdated = "last_updated"
        case vehicles
    }
}

// MARK: - Vehicle
struct Vehicle: Codable {
    let vehicleID: String?
    let lastGpsFix, lastGpsFixSecs: Int?
    let source: Source?
    let latitude, longitude: Double?
    let speed, heading: Int?
    let serviceName, destination, journeyID, nextStopID: String?
    let vehicleType: VehicleType?
    let ineoGpsFix: Int?
    let icomeraGpsFix: Int?

    enum CodingKeys: String, CodingKey {
        case vehicleID = "vehicle_id"
        case lastGpsFix = "last_gps_fix"
        case lastGpsFixSecs = "last_gps_fix_secs"
        case source, latitude, longitude, speed, heading
        case serviceName = "service_name"
        case destination
        case journeyID = "journey_id"
        case nextStopID = "next_stop_id"
        case vehicleType = "vehicle_type"
        case ineoGpsFix = "ineo_gps_fix"
        case icomeraGpsFix = "icomera_gps_fix"
    }
}

enum Source: String, Codable {
    case icomeraWiFi = "Icomera Wi-Fi"
    case myBusTracker = "MyBusTracker"
}

enum VehicleType: String, Codable {
    case bus = "bus"
}
