// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stopServices = try? JSONDecoder().decode(StopServices.self, from: jsonData)

import Foundation

// MARK: - StopServices
struct StopServices: Codable {
    let stopID, stopName: String
    let departures: [Departure]

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case stopName = "stop_name"
        case departures
    }
}

// MARK: - Departure
struct Departure: Codable {
    let serviceName: String
    let destination: Destination
    let noteID: Int?
    let validFrom, day: Int
    let time: String

    enum CodingKeys: String, CodingKey {
        case serviceName = "service_name"
        case destination
        case noteID = "note_id"
        case validFrom = "valid_from"
        case day, time
    }
}

enum Destination: String, Codable {
    case broughton = "Broughton"
    case edinburgh = "Edinburgh"
    case haymarket = "Haymarket"
    case longstone = "Longstone"
    case wallyford = "Wallyford"
    case whitecraig = "Whitecraig"
}
