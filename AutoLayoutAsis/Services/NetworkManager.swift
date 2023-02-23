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
    
    public var latitude: Double?
    
    public var longitude: Double?
    
    static let sharedInstance = NetworkManager()
    let session: Session
    let serverTrustPolicies: [String: ServerTrustEvaluating]
        
    public init() {
        serverTrustPolicies = [
            "tfe-opendata.com": PinnedCertificatesTrustEvaluator(certificates: [NetworkManager.certificate()], acceptSelfSignedCertificates: false)
        ]
        
        self.session = Session(serverTrustManager: ServerTrustManager(evaluators: serverTrustPolicies))
            
        let sessionConfiguration = URLSessionConfiguration.af.default
        sessionConfiguration.timeoutIntervalForResource = 60
        sessionConfiguration.timeoutIntervalForRequest = 60
        sessionConfiguration.httpAdditionalHeaders = HTTPHeaders.default.dictionary
        sessionConfiguration.requestCachePolicy = .useProtocolCachePolicy
        sessionConfiguration.urlCredentialStorage = nil
    }
        
    static func certificate() -> SecCertificate {
        guard let certificatePath = Bundle.main.path(forResource: "open-data", ofType: "cer") else {
            fatalError("Sertifika bulunamadı.")
        }
            
        let certificateData = try! Data(contentsOf: URL(fileURLWithPath: certificatePath))
        guard let certificate = SecCertificateCreateWithData(nil, certificateData as CFData) else {
            fatalError("Sertifika oluşturulamadı.")
        }
        return certificate
    }
    
    
    // MARK: -Fetch Stations
    public func fetchStations(completion: @escaping (DataResponse<StationModel, AFError>) -> Void) {
        session.request("https://tfe-opendata.com/api/v1/stops")
            .validate()
            .responseDecodable(of: StationModel.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch Services
    public func fetchServices(completion: @escaping (_ result: DataResponse<ServiceModel, AFError>) -> Void) {
        session.request("https://tfe-opendata.com/api/v1/services")
            .validate()
            .responseDecodable(of: ServiceModel.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch Live Vehicles
    public func fetchLiveVehicles(completion: @escaping (_ result: DataResponse<VehicleModel, AFError>) -> Void) {
        session.request("https://tfe-opendata.com/api/v1/vehicle_locations")
            .validate()
            .responseDecodable(of: VehicleModel.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch Stop Services
    public func fetchStopServices(completion: @escaping (_ result: DataResponse<StopServices, AFError>) -> Void) {
        session.request("https://tfe-opendata.com/api/v1/timetables/\(stopID!)")
            .validate()
            .responseDecodable(of: StopServices.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch RouteMaps
    public func fetchRouteMaps(completion: @escaping (_ result: DataResponse<RouteMaps, AFError>) -> Void) {
        session.request("https://maps.googleapis.com/maps/api/directions/json?alternatives=true&key=\(apiKey!)&destination=\(destination!)&origin=\(origin!)&mode=transit&transit_routing_preference=fewer_transfers&transit_mode=bus&language=tr")
            .validate()
            .responseDecodable(of: RouteMaps.self) { response in
            completion(response)
        }
    }
    
    // MARK: -Fetch PlaceID
    public func fetchPlaceID(completion: @escaping (_ result: DataResponse<PlaceIDRequest, AFError>) -> Void) {
        session.request("https://maps.googleapis.com/maps/api/geocode/json?key=\(apiKey!)&latlng=\(latitude!),\(longitude!)&language=tr&region=tr")
            .validate()
            .responseDecodable(of: PlaceIDRequest.self) { response in
            completion(response)
        }
    }
}


