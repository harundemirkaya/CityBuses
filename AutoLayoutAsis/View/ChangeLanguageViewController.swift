//
//  ChangeLanguageViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit

// MARK: -Change Language Class
class ChangeLanguageViewController: UIViewController {

    // MARK: -Define
    
    // MARK: Button Defined
    var btnChange: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("btnChangeLanguage".localized(), for: .normal)
        btn.isAccessibilityElement = true
        btn.accessibilityHint = "btnChangeLanguage".localized()
        btn.layer.cornerRadius = 6.0
        btn.backgroundColor = .purple
        return btn
    }()
    
    // MARK: Title Label Defined
    var lblTitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "changeLanguageTitle".localized()
        label.isAccessibilityElement = true
        label.accessibilityHint = "changeLanguageTitle".localized()
        label.font = UIFont.boldSystemFont(ofSize: 28.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: Button Added Screen and Added Button Function
        btnChange.btnChangeLanguageConstraints(view)
        lblTitle.lblTitleConstraints(view)
        btnChange.addTarget(self, action: #selector(changeLanguage), for: .touchUpInside)
    }
    
    // MARK: -Change Language Button Clicked
    @objc func changeLanguage(){
        if LocalizationSystem.sharedInstance.getLanguage() == "en" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "tr")
            alertMessage(title: NSLocalizedString("successTitle", comment: "Success Title"), description: NSLocalizedString("successChangeLanguage", comment: "Success Change Language"))
        } else{
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            alertMessage(title: NSLocalizedString("successTitle", comment: "Success Title"), description: NSLocalizedString("successChangeLanguage", comment: "Success Change Language"))
        }
    }
    
    // MARK: -Show Alert Message
    func alertMessage(title: String, description: String){
        let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: NSLocalizedString("btnOkey", comment: "Alert Okey Button"), style: UIAlertAction.Style.default)
        alertMessage.addAction(okButton)
        alertMessage.isAccessibilityElement = true
        alertMessage.accessibilityHint = description
        self.present(alertMessage, animated: true)
    }
}

// MARK: -Constraints
public extension UIView{
    func btnChangeLanguageConstraints(_ view: UIView){
        view.addSubview(self)
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
}
