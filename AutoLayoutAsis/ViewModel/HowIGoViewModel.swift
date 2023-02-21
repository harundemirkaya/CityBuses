//
//  HowIGoViewModel.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 17.02.2023.
//
// MARK: -Import Libaries
import Foundation

// MARK: -HowIGo View Model
class HowIGoViewModel{
    var howIGoVC: HowIGoViewController?
    
    // MARK: Network Manager Defined
    var networkManager = NetworkManager()
    
    func getStations(){
        networkManager.fetchStations { [weak self] result in
            if result.response?.statusCode == 200{
                self?.howIGoVC?.stations = result.value?.stops
            } else{
                self?.howIGoVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
    
    func getPlaceID(apiKey: String, latitude: Double, longitude: Double, fromOrTo: Int){
        networkManager.apiKey = apiKey
        networkManager.latitude = latitude
        networkManager.longitude = longitude
        networkManager.fetchPlaceID { result in
            if fromOrTo == 0{
                self.howIGoVC?.fromPlaceID = result.value?.results[0].placeID
            } else{
                self.howIGoVC?.toPlaceID = result.value?.results[0].placeID
            }
        }
    }
    
    func getDirections(apiKey: String, origin: String, destination: String){
        networkManager.apiKey = apiKey
        networkManager.origin = origin
        networkManager.destination = destination
        networkManager.fetchRouteMaps { result in
            self.howIGoVC?.routeMaps = result.value
        }
    }
}
