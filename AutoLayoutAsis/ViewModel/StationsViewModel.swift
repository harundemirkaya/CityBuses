//
//  StationsViewModel.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 30.01.2023.
//
// MARK: -Import Libaries
import Foundation

// MARK: -Stations Class
class StationsViewModel{
    
    // MARK: -Define
    
    // MARK: Network Manager Defined
    let networkManager = NetworkManager()
    
    // MARK: StationsVC Defined
    var stationsVC: StationsViewController?
    
    // MARK: -Fetch Stations
    func getStations(){
        networkManager.fetchStations { [weak self] result in
            if result.response?.statusCode == 200{
                self?.stationsVC?.stations = result.value?.stops
            } else{
                self?.stationsVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
}
