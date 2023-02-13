//
//  HowCanIgo.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 9.02.2023.
//
// MARK: -Import Libaries
import Foundation

// MARK: -HowCanIgoViewModel Class
class HowCanIgoViewModel{
    
    // MARK: -Define
    
    // MARK: HowCanIgoVC Defined
    var howCanIgoVC: HowCanIgoViewController?
    
    // MARK: Network Manager Defined
    var networkManager = NetworkManager()
    
    // MARK: Selected Stop ID
    var selectedStopID = 0
    
    // MARK: -Get Stations
    func getStations(){
        networkManager.fetchStations { [weak self] result in
            if result.response?.statusCode == 200{
                self?.howCanIgoVC?.stations = result.value?.stops
            } else{
                self?.howCanIgoVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
    
    // MARK: -Get Stop Services
    func getStopServices(){
        networkManager.stopID = selectedStopID
        networkManager.fetchStopServices { [weak self] result in
            if result.response?.statusCode == 200{
                self?.howCanIgoVC?.stopServices = result.value?.departures
            } else{
                self?.howCanIgoVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
    
    // MARK: -Get Services
    func getServices(){
        networkManager.fetchServices{ [weak self] result in
            if result.response?.statusCode == 200{
                self?.howCanIgoVC?.services = result.value?.services
            } else{
                self?.howCanIgoVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
}
