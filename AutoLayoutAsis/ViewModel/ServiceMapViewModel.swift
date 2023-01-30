//
//  ServiceMapViewModel.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 30.01.2023.
//
// MARK: -Import Libaries
import Foundation

// MARK: ServiceMapViewModel Class
class ServiceMapViewModel{
    
    // MARK: -Define
    
    // MARK: Network Manager Defined
    let networkManager = NetworkManager()
    
    // MARK: ServiceMapViewController Defined
    var serviceMapVC : ServiceMapViewController?
    
    // MARK: -Fetch Bus
    func getBus(){
        networkManager.fetchLiveVehicles { [weak self] result in
            if result.response?.statusCode == 200{
                self?.serviceMapVC?.vehicles = result.value?.vehicles
            } else{
                self?.serviceMapVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
}
