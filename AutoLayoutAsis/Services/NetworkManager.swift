//
//  NetworkManager.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    public func fetchStations(completion: @escaping (_ result: DataResponse<StationModel, AFError>) -> Void) {
        AF.request("https://tfe-opendata.com/api/v1/stops").responseDecodable(of: StationModel.self) { response in
            completion(response)
        }
    }
    
    public func fetchServices(completion: @escaping (_ result: DataResponse<ServiceModel, AFError>) -> Void) {
        AF.request("https://tfe-opendata.com/api/v1/services").responseDecodable(of: ServiceModel.self) { response in
            completion(response)
        }
    }
    
    public func fetchLiveVehicles(completion: @escaping (_ result: DataResponse<VehicleModel, AFError>) -> Void) {
        AF.request("https://tfe-opendata.com/api/v1/vehicle_locations").responseDecodable(of: VehicleModel.self) { response in
            completion(response)
        }
    }
}


