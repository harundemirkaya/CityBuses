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

    var btnChange: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("btnChangeLanguage", comment: "Change Language Button"), for: .normal)
        btn.backgroundColor = .gray
        return btn
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: Button Added Screen and Added Button Function
        btnChange.btnConstraints(view)
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
            self.present(alertMessage, animated: true)
    }
}

// MARK: -Constraints
public extension UIView{
    func btnConstraints(_ view: UIView){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
