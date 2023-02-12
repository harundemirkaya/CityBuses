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
    
    // MARK: -Functions
    func getStations(){
        networkManager.fetchStations { [weak self] result in
            if result.response?.statusCode == 200{
                self?.howCanIgoVC?.stations = result.value?.stops
            } else{
                self?.howCanIgoVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
    
    func getPaths(startStopID: Int, finishStopID: Int){
        networkManager.startStopID = startStopID
        networkManager.finishStopID = finishStopID
        networkManager.fetchStopToStop { [weak self] result in
            if result.response?.statusCode == 200{
                self?.howCanIgoVC?.stopToStop = result.value
            } else{
                self?.howCanIgoVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
}
