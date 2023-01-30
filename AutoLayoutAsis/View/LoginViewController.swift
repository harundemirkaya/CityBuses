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
        txtField.placeholder = "emailPlaceHolder".localized()
        txtField.layer.cornerRadius = 4.0
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.gray.cgColor
        let paddingViewUsername = UIView(frame: CGRectMake(0, 0, 15, txtField.frame.height))
        txtField.leftView = paddingViewUsername
        txtField.leftViewMode = UITextField.ViewMode.always
        return txtField
    }()
    
    var txtFieldPassword: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "passwordPlaceHolder".localized()
        txtField.layer.cornerRadius = 4.0
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.gray.cgColor
        let paddingViewUsername = UIView(frame: CGRectMake(0, 0, 15, txtField.frame.height))
        txtField.leftView = paddingViewUsername
        txtField.leftViewMode = UITextField.ViewMode.always
        return txtField
    }()
    
    // MARK: Button's Defined
    var btnLogin: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("btnLogin".localized(), for: .normal)
        btn.layer.cornerRadius = 6.0
        btn.backgroundColor = .purple
        return btn
    }()
    
    var btnRegister: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("btnRegister".localized(), for: .normal)
        btn.layer.cornerRadius = 6.0
        btn.backgroundColor = .purple
        return btn
    }()
    
    // MARK: Label Defined
    var lblTitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "login".localized()
        label.font = UIFont.boldSystemFont(ofSize: 28.0)
        return label
    }()
    
    var lblUsername: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "username".localized()
        label.textAlignment = .left
        label.font = label.font.withSize(14)
        return label
    }()
    
    var lblPassword: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "password".localized()
        label.font = label.font.withSize(14)
        return label
    }()

    let loginViewModel = LoginViewModel()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white

        btnLogin.addTarget(self, action: #selector(btnLoginTarget), for: .touchUpInside)
        view.addSubview(btnLogin)
        btnRegister.addTarget(self, action: #selector(btnRegisterTarget), for: .touchUpInside)
        view.addSubview(btnRegister)
        
        // MARK: for Close Keyboard
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
        // MARK: Constraints Defined
        txtFieldUserName.txtUserNameConstraints(view)
        txtFieldPassword.txtPasswordConstraints(view, txtFieldUserName: txtFieldUserName)
        btnLogin.btnLoginConstraints(view, txtFieldPassword: txtFieldPassword)
        btnRegister.btnRegisterConstraints(view, btnLogin: btnLogin)
        lblTitle.lblTitle(view)
        lblUsername.lblTxtFieldLabel(view, txtField: txtFieldUserName)
        lblPassword.lblTxtFieldLabel(view, txtField: txtFieldPassword)
        
        // MARK: View Model Connect
        loginViewModel.loginVC = self
    }

    // MARK: -Register Button Clicked
    @objc func btnRegisterTarget(){
        if txtFieldUserName.text != "" && txtFieldPassword.text != ""{
            loginViewModel.btnRegisterClicked()
        } else{
            self.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error Title"), description: NSLocalizedString("fillAllField", comment: "Fill All Field"))
        }
    }
    
    // MARK: -Login Button Clicked
    @objc func btnLoginTarget(){
        if txtFieldUserName.text != "" && txtFieldPassword.text != ""{
            loginViewModel.btnLoginClicked()
        } else{
            self.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error Title"), description: NSLocalizedString("fillAllField", comment: "Fill All Field"))
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

public extension UIView{
    func lblTitle(_ view: UIView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65).isActive = true
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
    
    func lblTxtFieldLabel(_ view: UIView, txtField: UITextField){
        view.addSubview(self)
        bottomAnchor.constraint(equalTo: txtField.topAnchor, constant: -10).isActive = true
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
    
    func lblPassword(_ view: UIView, txtFieldPassword: UITextField){
        view.addSubview(self)
        bottomAnchor.constraint(equalTo: txtFieldPassword.topAnchor, constant: -10).isActive = true
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
    
    func txtUserNameConstraints(_ view: UIView){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func txtPasswordConstraints(_ view: UIView,  txtFieldUserName: UITextField){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        topAnchor.constraint(equalTo: txtFieldUserName.bottomAnchor, constant: 40).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func btnLoginConstraints(_ view: UIView, txtFieldPassword: UITextField){
        view.addSubview(self)
        topAnchor.constraint(equalTo: txtFieldPassword.bottomAnchor, constant: 50).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
    
    func btnRegisterConstraints(_ view: UIView, btnLogin: UIButton){
        view.addSubview(self)
        topAnchor.constraint(equalTo: btnLogin.bottomAnchor, constant: 10).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
}
