//
//  Polyline.swift
//  BaseApp
//
//  Created by Şükrü Can Avcı on 19.11.2022.
//

import Foundation
import CoreLocation
import MapKit

public struct PolylineDecode {
    
    public let coordinates: [CLLocationCoordinate2D]?
    public let encodedPolyline: String
    public let levels: [UInt32]?
    public let encodedLevels: String?
    public var locations: [CLLocation]? {
        return self.coordinates.map(toLocations)
    }

    // MARK: - Public Methods -
    public init(coordinates: [CLLocationCoordinate2D], levels: [UInt32]? = nil, precision: Double = 1e5) {
        
        self.coordinates = coordinates
        self.levels = levels
        
        encodedPolyline = encodeCoordinates(coordinates, precision: precision)
        
        encodedLevels = levels.map(encodeLevels)
    }

    public init(encodedPolyline: String, encodedLevels: String? = nil, precision: Double = 1e5) {
        
        self.encodedPolyline = encodedPolyline
        self.encodedLevels = encodedLevels
        
        coordinates = decodePolyline(encodedPolyline, precision: precision)

        levels = self.encodedLevels.flatMap(decodeLevels)
    }

}

public func encodeCoordinates(_ coordinates: [CLLocationCoordinate2D], precision: Double = 1e5) -> String {
    
    var previousCoordinate = IntegerCoordinates(0, 0)
    var encodedPolyline = ""
    
    for coordinate in coordinates {
        let intLatitude  = Int(round(coordinate.latitude * precision))
        let intLongitude = Int(round(coordinate.longitude * precision))
        
        let coordinatesDifference = (intLatitude - previousCoordinate.latitude, intLongitude - previousCoordinate.longitude)
        
        encodedPolyline += encodeCoordinate(coordinatesDifference)
        
        previousCoordinate = (intLatitude,intLongitude)
    }
    
    return encodedPolyline
}

public func encodeLocations(_ locations: [CLLocation], precision: Double = 1e5) -> String {
    
    return encodeCoordinates(toCoordinates(locations), precision: precision)
}

public func encodeLevels(_ levels: [UInt32]) -> String {
    return levels.reduce("") {
        $0 + encodeLevel($1)
    }
}

public func decodePolyline(_ encodedPolyline: String, precision: Double = 1e5) -> [CLLocationCoordinate2D]? {
    let data = encodedPolyline.data(using: .utf8)!
    return data.withUnsafeBytes { byteArray -> [CLLocationCoordinate2D]? in
        let length = data.count
        var position = 0
        
        var decodedCoordinates = [CLLocationCoordinate2D]()
        
        var lat = 0.0
        var lon = 0.0
        
        while position < length {
            do {
                let resultingLat = try decodeSingleCoordinate(byteArray: byteArray, length: length, position: &position, precision: precision)
                lat += resultingLat
                
                let resultingLon = try decodeSingleCoordinate(byteArray: byteArray, length: length, position: &position, precision: precision)
                lon += resultingLon
            } catch {
                return nil
            }
            
            decodedCoordinates.append(CLLocationCoordinate2D(latitude: lat, longitude: lon))
        }
        
        return decodedCoordinates
    }
}

public func decodePolyline(_ encodedPolyline: String, precision: Double = 1e5) -> [CLLocation]? {
    
    return decodePolyline(encodedPolyline, precision: precision).map(toLocations)
}

public func decodeLevels(_ encodedLevels: String) -> [UInt32]? {
    var remainingLevels = encodedLevels.unicodeScalars
    var decodedLevels   = [UInt32]()
    
    while remainingLevels.count > 0 {
        
        do {
            let chunk = try extractNextChunk(&remainingLevels)
            let level = decodeLevel(chunk)
            decodedLevels.append(level)
        } catch {
            return nil
        }
    }
    
    return decodedLevels
}


// MARK: - Private -
// MARK: Encode Coordinate
private func encodeCoordinate(_ locationCoordinate: IntegerCoordinates) -> String {
    
    let latitudeString  = encodeSingleComponent(locationCoordinate.latitude)
    let longitudeString = encodeSingleComponent(locationCoordinate.longitude)
    
    return latitudeString + longitudeString
}

private func encodeSingleComponent(_ value: Int) -> String {
    
    var intValue = value
    
    if intValue < 0 {
        intValue = intValue << 1
        intValue = ~intValue
    } else {
        intValue = intValue << 1
    }
    
    return encodeFiveBitComponents(intValue)
}

// MARK: Encode Levels
private func encodeLevel(_ level: UInt32) -> String {
    return encodeFiveBitComponents(Int(level))
}

private func encodeFiveBitComponents(_ value: Int) -> String {
    var remainingComponents = value
    
    var fiveBitComponent = 0
    var returnString = String()
    
    repeat {
        fiveBitComponent = remainingComponents & 0x1F
        
        if remainingComponents >= 0x20 {
            fiveBitComponent |= 0x20
        }
        
        fiveBitComponent += 63

        let char = UnicodeScalar(fiveBitComponent)!
        returnString.append(String(char))
        remainingComponents = remainingComponents >> 5
    } while (remainingComponents != 0)
    
    return returnString
}

private func decodeSingleCoordinate(byteArray: UnsafeRawBufferPointer, length: Int, position: inout Int, precision: Double = 1e5) throws -> Double {
    
    guard position < length else { throw PolylineError.singleCoordinateDecodingError }
    
    let bitMask = Int8(0x1F)
    
    var coordinate: Int32 = 0
    
    var currentChar: Int8
    var componentCounter: Int32 = 0
    var component: Int32 = 0
    
    repeat {
        currentChar = Int8(byteArray[position]) - 63
        component = Int32(currentChar & bitMask)
        coordinate |= (component << (5*componentCounter))
        position += 1
        componentCounter += 1
    } while ((currentChar & 0x20) == 0x20) && (position < length) && (componentCounter < 6)
    
    if (componentCounter == 6) && ((currentChar & 0x20) == 0x20) {
        throw PolylineError.singleCoordinateDecodingError
    }
    
    if (coordinate & 0x01) == 0x01 {
        coordinate = ~(coordinate >> 1)
    } else {
        coordinate = coordinate >> 1
    }
    
    return Double(coordinate) / precision
}

// MARK: Decode Levels
private func extractNextChunk(_ encodedString: inout String.UnicodeScalarView) throws -> String {
    var currentIndex = encodedString.startIndex
    
    while currentIndex != encodedString.endIndex {
        let currentCharacterValue = Int32(encodedString[currentIndex].value)
        if isSeparator(currentCharacterValue) {
            let extractedScalars = encodedString[encodedString.startIndex...currentIndex]
            encodedString = String.UnicodeScalarView(encodedString[encodedString.index(after: currentIndex)..<encodedString.endIndex])
            
            return String(extractedScalars)
        }
        
        currentIndex = encodedString.index(after: currentIndex)
    }
    
    throw PolylineError.chunkExtractingError
}

private func decodeLevel(_ encodedLevel: String) -> UInt32 {
    let scalarArray = [] + encodedLevel.unicodeScalars
    
    return UInt32(agregateScalarArray(scalarArray))
}

private func agregateScalarArray(_ scalars: [UnicodeScalar]) -> Int32 {
    let lastValue = Int32(scalars.last!.value)
    
    let fiveBitComponents: [Int32] = scalars.map { scalar in
        let value = Int32(scalar.value)
        if value != lastValue {
            return (value - 63) ^ 0x20
        } else {
            return value - 63
        }
    }
    
    return Array(fiveBitComponents.reversed()).reduce(0) { ($0 << 5 ) | $1 }
}

// MARK: Utilities
enum PolylineError: Error {
    case singleCoordinateDecodingError
    case chunkExtractingError
}

private func toCoordinates(_ locations: [CLLocation]) -> [CLLocationCoordinate2D] {
    return locations.map {location in location.coordinate}
}

private func toLocations(_ coordinates: [CLLocationCoordinate2D]) -> [CLLocation] {
    return coordinates.map { coordinate in
        CLLocation(latitude:coordinate.latitude, longitude:coordinate.longitude)
    }
}

private func isSeparator(_ value: Int32) -> Bool {
    return (value - 63) & 0x20 != 0x20
}

private typealias IntegerCoordinates = (latitude: Int, longitude: Int)
