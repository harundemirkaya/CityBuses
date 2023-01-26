//
//  SettingsViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import UIKit
import Firebase

final class SettingsViewController: UIViewController {
    
    var txtFieldEmail: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = Auth.auth().currentUser?.email
        txtField.borderStyle = .bezel
        return txtField
    }()
    
    var btnUpdate: UIButton = {
        let btn = UIButton()
        btn.setTitle("Update", for: .normal)
        btn.backgroundColor = .gray
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        requestCurrentuser()
        txtFieldEmail.txtFieldEmail(view)
        btnUpdate.btnUpdate(view, with: txtFieldEmail)
        btnUpdate.addTarget(self, action: #selector(btnUpdateTarget), for: .touchUpInside)
    }
    
    func requestCurrentuser(){
        if Auth.auth().currentUser == nil{
            let homeVC = HomeViewController()
            self.navigationController?.pushViewController(homeVC, animated: true)
        }
    }
    
    @objc func btnUpdateTarget(){
        if txtFieldEmail.text != ""{
            Auth.auth().currentUser?.updateEmail(to: txtFieldEmail.text!)
            self.alertMessage(title: "Success", description: "Your email address has been successfully changed.")
        } else{
            self.alertMessage(title: "Error", description: "Please fill in all fields")
        }
    }
    
    func alertMessage(title: String, description: String){
            let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: "Okey", style: UIAlertAction.Style.default)
            alertMessage.addAction(okButton)
            self.present(alertMessage, animated: true)
    }
}

// Constraints
public extension UIView {
    func txtFieldEmail(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func btnUpdate(_ view: UIView, with txtFieldEmail: UITextField) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: txtFieldEmail.bottomAnchor, constant: 10).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
