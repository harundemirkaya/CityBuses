//
//  WhereMyBusViewModel.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 30.01.2023.
//
// MARK: -Import Libaries
import Foundation

// MARK: -WhereMyBusViewModel Class
class WhereMyBusViewModel{
    
    // MARK: -Define
    
    // MARK: Network Manager Defined
    let networkManager = NetworkManager()
    
    // MARK: whereMyBusVC Defined
    var whereMyBusVC: WhereMyBusViewController?
    
    // MARK: -Fetch Services
    func getServices(){
        networkManager.fetchServices{ [weak self] result in
            if result.response?.statusCode == 200{
                self?.whereMyBusVC?.services = result.value?.services
            } else{
                self?.whereMyBusVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
        }
    }
}
