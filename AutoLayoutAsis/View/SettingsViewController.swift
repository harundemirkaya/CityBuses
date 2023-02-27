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
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = Auth.auth().currentUser?.email
        txtField.isAccessibilityElement = true
        txtField.accessibilityHint = "E-Mail"
        txtField.layer.cornerRadius = 4.0
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.gray.cgColor
        let paddingViewUsername = UIView(frame: CGRectMake(0, 0, 15, txtField.frame.height))
        txtField.leftView = paddingViewUsername
        txtField.leftViewMode = UITextField.ViewMode.always
        txtField.backgroundColor = .white
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        return txtField
    }()
    
    // MARK: -Button Defined
    var btnUpdate: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("btnUpdate".localized(), for: .normal)
        btn.isAccessibilityElement = true
        btn.accessibilityHint = "btnUpdate".localized()
        btn.layer.cornerRadius = 6.0
        btn.backgroundColor = .purple
        return btn
    }()

    // MARK: Title Label Defined
    var lblTitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "settingsTitle".localized()
        label.isAccessibilityElement = true
        label.accessibilityHint = "settingsTitle".localized()
        label.font = UIFont.boldSystemFont(ofSize: 28.0)
        return label
    }()
    
    // MARK: -Page Title Defined
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("settingPageTitle", comment: "Settings Page Title")
        label.isAccessibilityElement = true
        label.accessibilityHint = NSLocalizedString("settingPageTitle", comment: "Settings Page Title")
        return label
    }
    
    let btnBack: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        btn.setTitle("btnBack".localized(), for: .normal)
        btn.setTitleColor(.black, for: .normal)
        btn.tintColor = .black
        return btn
    }()
    
    let settingsViewModel = SettingsViewModel()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        navigationItem.titleView = pageTitle
        navigationController?.navigationBar.isHidden = true
        pageTitle.pageTitleConstraints(view)
        
        // MARK: Settings View Model Connect
        settingsViewModel.settingsVC = self
        
        // MARK: User Session Control
        settingsViewModel.requestCurrentuser()
        
        // MARK: TextFields and Button
        txtFieldEmail.txtFieldEmail(view)
        btnUpdate.btnUpdate(view, with: txtFieldEmail)
        btnBack.btnBackConstraints(view)
        btnUpdate.addTarget(self, action: #selector(settingsViewModel.btnUpdateTarget), for: .touchUpInside)
        btnBack.addTarget(self, action: #selector(btnBackTarget), for: .touchUpInside)
    }
    
    @objc func btnBackTarget(){
        let appTabBar = AppTabBarController()
        appTabBar.modalPresentationStyle = .fullScreen
        navigationController?.navigationBar.isHidden = false
        present(appTabBar, animated: true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        navigationController?.navigationBar.isHidden = false
    }
    
    // MARK: -Show Alert Message
    func alertMessage(title: String, description: String){
        let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: NSLocalizedString("btnOkey", comment: "Okey Button"), style: UIAlertAction.Style.default)
        alertMessage.addAction(okButton)
        alertMessage.isAccessibilityElement = true
        alertMessage.accessibilityHint = description
        self.present(alertMessage, animated: true)
    }
}

// MARK: -Constraints
public extension UIView {
    func txtFieldEmail(_ view: UIView){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func btnUpdate(_ view: UIView, with txtFieldEmail: UITextField) {
        view.addSubview(self)
        topAnchor.constraint(equalTo: txtFieldEmail.bottomAnchor, constant: 10).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
    
    func pageTitleConstraints(_ view: UIView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func btnBackConstraints(_ view: UIView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 10).isActive = true
    }
}
