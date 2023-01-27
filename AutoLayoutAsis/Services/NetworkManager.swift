//
//  NetworkManager.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import Foundation
import Alamofire
import SwiftyJSON

// MARK: -Network Class
class NetworkManager {
    
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
}


