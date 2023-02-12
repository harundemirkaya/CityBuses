// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let stopToStop = try? JSONDecoder().decode(StopToStop.self, from: jsonData)

import Foundation

// MARK: - StopToStop
struct StopToStop: Codable {
    let startStopID, finishStopID, date, duration: Int
    let journeys: [Journey]

    enum CodingKeys: String, CodingKey {
        case startStopID = "start_stop_id"
        case finishStopID = "finish_stop_id"
        case date, duration, journeys
    }
}

// MARK: - Journey
struct Journey: Codable {
    let serviceName, destination: String
    let departures: [Departure]

    enum CodingKeys: String, CodingKey {
        case serviceName = "service_name"
        case destination, departures
    }
}

// MARK: - Departure
struct Departure: Codable {
    let stopID: Int
    let name, time: String
    let timingPoint: Bool

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case name, time
        case timingPoint = "timing_point"
    }
}
