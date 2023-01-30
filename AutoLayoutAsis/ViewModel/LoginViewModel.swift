//
//  LoginViewModel.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 30.01.2023.
//
// MARK: -Import Libaries
import Foundation
import Firebase

// MARK: LoginViewModelClass
class LoginViewModel{
    
    // MARK: -Define
    
    // MARK: LoginVC Defined
    var loginVC: LoginViewController?
    
    func btnLoginClicked(){
        Auth.auth().signIn(withEmail: (loginVC?.txtFieldUserName.text)!, password: (loginVC?.txtFieldPassword.text)!){
            AuthDataResult, err in
            if err != nil{
                self.loginVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error Title"), description: err!.localizedDescription)
            } else{
                let homeVC = HomeViewController()
                self.loginVC?.navigationController?.pushViewController(homeVC, animated: true)
                self.loginVC?.tabBarController?.tabBar.isHidden = false
                self.loginVC?.navigationController?.isNavigationBarHidden = false
            }
        }
    }
    
    func btnRegisterClicked(){
        Auth.auth().createUser(withEmail: (loginVC?.txtFieldUserName.text)!, password: (loginVC?.txtFieldPassword.text)!) {
            authDataResult, err in
            if err != nil{
                self.loginVC?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error Title"), description: err!.localizedDescription)
            }
            else{
                let homeVC = HomeViewController()
                self.loginVC?.navigationController?.pushViewController(homeVC, animated: true)
                self.loginVC?.tabBarController?.tabBar.isHidden = false
                self.loginVC?.navigationController?.isNavigationBarHidden = false
            }
        }
    }
}
