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
}
