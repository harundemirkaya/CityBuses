//
//  ViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 23.01.2023.
//

import UIKit
import FirebaseAuth

class ViewController: UIViewController {
    
    var txtFieldUserName: UITextField!
    var txtFieldPassword: UITextField!
    var btnLogin: UIButton!
    var btnRegister: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        txtFieldUserName = UITextField()
        txtFieldUserName.placeholder = "E-Mail"
        txtFieldUserName.borderStyle = .bezel
        txtFieldUserName.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(txtFieldUserName)
        
        txtFieldPassword = UITextField()
        txtFieldPassword.placeholder = "Password"
        txtFieldPassword.borderStyle = .bezel
        txtFieldPassword.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(txtFieldPassword)
        
        btnLogin = UIButton()
        btnLogin.setTitle("Login", for: .normal)
        btnLogin.backgroundColor = .gray
        btnLogin.addTarget(self, action: #selector(btnLoginTarget), for: .touchUpInside)
        btnLogin.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnLogin)
        
        btnRegister = UIButton()
        btnRegister.setTitle("Register", for: .normal)
        btnRegister.backgroundColor = .gray
        btnRegister.addTarget(self, action: #selector(btnRegisterTarget), for: .touchUpInside)
        btnRegister.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(btnRegister)
        
        
        let constraints = [
            txtFieldUserName.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            txtFieldUserName.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            
            txtFieldUserName.widthAnchor.constraint(equalTo: view.widthAnchor),
    
            txtFieldPassword.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            txtFieldPassword.topAnchor.constraint(equalTo: txtFieldUserName.bottomAnchor, constant: 10),
            txtFieldPassword.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            btnLogin.topAnchor.constraint(equalTo: txtFieldPassword.bottomAnchor, constant: 10),
            btnLogin.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnLogin.widthAnchor.constraint(equalTo: view.widthAnchor),
            
            btnRegister.topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 10),
            btnRegister.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            btnRegister.widthAnchor.constraint(equalTo: view.widthAnchor)
            
        ]
        NSLayoutConstraint.activate(constraints)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let currentUser = Auth.auth().currentUser
        if currentUser != nil{
            let homeVC = HomeViewController()
            navigationController?.pushViewController(homeVC, animated: false)
        }
    }

    @objc func btnRegisterTarget(){
        if txtFieldUserName.text != "" && txtFieldPassword.text != ""{
            Auth.auth().createUser(withEmail: txtFieldUserName.text!, password: txtFieldPassword.text!) {
                authDataResult, err in
                if err != nil{
                    self.alertMessage(title: "Error", description: err!.localizedDescription)
                }
                else{
                    let homeVC = HomeViewController()
                    self.navigationController?.pushViewController(homeVC, animated: true)
                    
                }
            }
        } else{
            self.alertMessage(title: "Error", description: "Please fill in all fields")
        }
    }
    
    @objc func btnLoginTarget(){
        if txtFieldUserName.text != "" && txtFieldPassword.text != ""{
            Auth.auth().signIn(withEmail: txtFieldUserName.text!, password: txtFieldPassword.text!){
                AuthDataResult, err in
                if err != nil{
                    self.alertMessage(title: "Error", description: err!.localizedDescription)
                } else{
                    let homeVC = HomeViewController()
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        }
    }
    
    func alertMessage(title: String, description: String){
            let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Okey", style: UIAlertAction.Style.default)
            alertMessage.addAction(okButton)
            self.present(alertMessage, animated: true)
    }

}

