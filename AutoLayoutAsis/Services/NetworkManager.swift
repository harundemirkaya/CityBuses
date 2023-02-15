//
//  NetworkManager.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import Foundation
import Alamofire

// MARK: -Network Class
class NetworkManager {
    
    public var stopID: Int?
    
    public var apiKey: String?
    
    public var destination: String?
    
    public var origin: String?
    
    // MARK: -Fetch Stations
    public func fetchStations(completion: @escaping (_ result: DataResponse<StationModel, AFError>) -> Void) {
        AF.request("https://tfe-opendata.com/api/v1/stops").responseDecodable(of: StationModel.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch Services
    public func fetchServices(completion: @escaping (_ result: DataResponse<ServiceModel, AFError>) -> Void) {
        AF.request("https://tfe-opendata.com/api/v1/services").responseDecodable(of: ServiceModel.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch Live Vehicles
    public func fetchLiveVehicles(completion: @escaping (_ result: DataResponse<VehicleModel, AFError>) -> Void) {
        AF.request("https://tfe-opendata.com/api/v1/vehicle_locations").responseDecodable(of: VehicleModel.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch Stop Services
    public func fetchStopServices(completion: @escaping (_ result: DataResponse<StopServices, AFError>) -> Void) {
        AF.request("https://tfe-opendata.com/api/v1/timetables/\(stopID!)").responseDecodable(of: StopServices.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch RouteMaps
    public func feetchRouteMaps(completion: @escaping (_ result: DataResponse<RouteMaps, AFError>) -> Void) {
        AF.request("https://maps.googleapis.com/maps/api/directions/json?alternatives=true&key=\(apiKey!)&destination=\(destination!)&origin=\(origin!)&mode=transit&transit_routing_preference=fewer_transfers&transit_mode=bus&language=tr").responseDecodable(of: RouteMaps.self) { response in
            completion(response)
        }
    }
}


