//
//  ViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 23.01.2023.
//
// MARK: -Import Libaries
import UIKit
import FirebaseAuth

// MARK: -Login View Class
class LoginViewController: UIViewController {
    
    // MARK: -Define
    
    // MARK: Text Field's Defined
    var txtFieldUserName: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = NSLocalizedString("emailPlaceHolder", comment: "Email Text Field Place Holder")
        txtField.borderStyle = .bezel
        return txtField
    }()
    
    var txtFieldPassword: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = NSLocalizedString("passwordPlaceHolder", comment: "Password Text Field Place Holder")
        txtField.borderStyle = .bezel
        return txtField
    }()
    
    // MARK: Button's Defined
    var btnLogin: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("btnLogin", comment: "Login Button Title"), for: .normal)
        btn.backgroundColor = .gray
        return btn
    }()
    
    var btnRegister: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("btnRegister", comment: "Register Button Title"), for: .normal)
        btn.backgroundColor = .gray
        return btn
    }()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: TextFields and Buttons Add Screen
        view.addSubview(txtFieldUserName)
        view.addSubview(txtFieldPassword)
        
        btnLogin.addTarget(self, action: #selector(btnLoginTarget), for: .touchUpInside)
        view.addSubview(btnLogin)
        btnRegister.addTarget(self, action: #selector(btnRegisterTarget), for: .touchUpInside)
        view.addSubview(btnRegister)
        
        // MARK: for Close Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // MARK: Constraints Defined
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

    // MARK: -Register Button Clicked
    @objc func btnRegisterTarget(){
        if txtFieldUserName.text != "" && txtFieldPassword.text != ""{
            Auth.auth().createUser(withEmail: txtFieldUserName.text!, password: txtFieldPassword.text!) {
                authDataResult, err in
                if err != nil{
                    self.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error Title"), description: err!.localizedDescription)
                }
                else{
                    let homeVC = HomeViewController()
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        } else{
            self.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error Title"), description: NSLocalizedString("fillAllField", comment: "Fill All Field"))
        }
    }
    
    // MARK: -Login Button Clicked
    @objc func btnLoginTarget(){
        if txtFieldUserName.text != "" && txtFieldPassword.text != ""{
            Auth.auth().signIn(withEmail: txtFieldUserName.text!, password: txtFieldPassword.text!){
                AuthDataResult, err in
                if err != nil{
                    self.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error Title"), description: err!.localizedDescription)
                } else{
                    let homeVC = HomeViewController()
                    self.navigationController?.pushViewController(homeVC, animated: true)
                }
            }
        }
    }
    
    // MARK: -Show Alert Message
    func alertMessage(title: String, description: String){
            let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: NSLocalizedString("btnOkey", comment: "Alert Okey Button"), style: UIAlertAction.Style.default)
            alertMessage.addAction(okButton)
            self.present(alertMessage, animated: true)
    }
    
    // MARK: -Close Keyboard Function
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}

