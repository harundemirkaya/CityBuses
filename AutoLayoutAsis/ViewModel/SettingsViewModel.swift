//
//  SettingsViewModel.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 30.01.2023.
//
// MARK: -Import Libaries
import Foundation
import Firebase

// MARK: -SettingsViewModel Class
class SettingsViewModel{
    
    // MARK: -Define
    
    // MARK: Settings View Controller Defined
    var settingsVC: SettingsViewController?
    
    // MARK: -User Session Control Function
    func requestCurrentuser(){
        if Auth.auth().currentUser == nil{
            let homeVC = HomeViewController()
            self.settingsVC?.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    // MARK: -Update Button Clicked
    @objc func btnUpdateTarget(){
        if settingsVC?.txtFieldEmail.text != ""{
            Auth.auth().currentUser?.updateEmail(to: (settingsVC?.txtFieldEmail.text)!)
            self.settingsVC?.alertMessage(title: NSLocalizedString("successTitle", comment: "Succes Alert Title"), description: NSLocalizedString("changeMailSuccessAlertDescription", comment: "Change E Mail Success Alert Description"))
        } else{
            self.settingsVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error Title"), description: NSLocalizedString("fillAllField", comment: "Fill All Fields"))
        }
    }
}
