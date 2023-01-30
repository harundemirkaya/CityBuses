//
//  SettingsViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit
import Firebase

// MARK: -Settings Class
final class SettingsViewController: UIViewController {
    
    // MARK: -Define
    
    // MARK: -Text Field Defined
    var txtFieldEmail: UITextField = {
        let txtField = UITextField()
        txtField.placeholder = Auth.auth().currentUser?.email
        txtField.borderStyle = .bezel
        return txtField
    }()
    
    // MARK: -Button Defined
    var btnUpdate: UIButton = {
        let btn = UIButton()
        btn.setTitle(NSLocalizedString("btnUpdate", comment: "Update Button"), for: .normal)
        btn.backgroundColor = .gray
        return btn
    }()
    
    // MARK: -Page Title Defined
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("settingPageTitle", comment: "Settings Page Title")
        return label
    }
    
    let settingsViewModel = SettingsViewModel()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        navigationItem.titleView = pageTitle
        
        // MARK: Settings View Model Connect
        settingsViewModel.settingsVC = self
        
        // MARK: User Session Control
        settingsViewModel.requestCurrentuser()
        
        // MARK: TextFields and Button
        txtFieldEmail.txtFieldEmail(view)
        btnUpdate.btnUpdate(view, with: txtFieldEmail)
        btnUpdate.addTarget(self, action: #selector(settingsViewModel.btnUpdateTarget), for: .touchUpInside)
    }
    

    
    // MARK: -Show Alert Message
    func alertMessage(title: String, description: String){
            let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: NSLocalizedString("btnOkey", comment: "Okey Button"), style: UIAlertAction.Style.default)
            alertMessage.addAction(okButton)
            self.present(alertMessage, animated: true)
    }
}

// MARK: -Constraints
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
