//
//  PlaceIDRequest.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 21.02.2023.
//

import Foundation

// MARK: - PlaceIDRequest
struct PlaceIDRequest: Codable {
    let plusCode: PlusCode
    let results: [Result]
    let status: String

    enum CodingKeys: String, CodingKey {
        case plusCode = "plus_code"
        case results, status
    }
}

// MARK: - PlusCode
struct PlusCode: Codable {
    let compoundCode, globalCode: String

    enum CodingKeys: String, CodingKey {
        case compoundCode = "compound_code"
        case globalCode = "global_code"
    }
}

// MARK: - Result
struct Result: Codable {
    let addressComponents: [AddressComponent]
    let formattedAddress: String
    let geometry: Geometry
    let placeID: String
    let plusCode: PlusCode?
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case addressComponents = "address_components"
        case formattedAddress = "formatted_address"
        case geometry
        case placeID = "place_id"
        case plusCode = "plus_code"
        case types
    }
}

// MARK: - AddressComponent
struct AddressComponent: Codable {
    let longName, shortName: String
    let types: [String]

    enum CodingKeys: String, CodingKey {
        case longName = "long_name"
        case shortName = "short_name"
        case types
    }
}

// MARK: - Geometry
struct Geometry: Codable {
    let location: LocationRequest
    let locationType: String
    let viewport: Bounds
    let bounds: Bounds?

    enum CodingKeys: String, CodingKey {
        case location
        case locationType = "location_type"
        case viewport, bounds
    }
}

// MARK: - Bounds
struct Bounds: Codable {
    let northeast, southwest: LocationRequest
}

// MARK: - Location
struct LocationRequest: Codable {
    let lat, lng: Double
}
