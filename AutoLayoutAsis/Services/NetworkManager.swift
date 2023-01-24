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
    
    public func fetchStations(resultHandler: @escaping (_ result: DataResponse<StationResponseModel, AFError>) -> Void) {
        AF.request("https://tfe-opendata.com/api/v1/stops").responseDecodable(of: StationResponseModel.self) { response in
            resultHandler(response)
        }
    }
}


