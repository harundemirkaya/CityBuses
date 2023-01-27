//
//  BalanceViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit
import CoreNFC

// MARK: -Balance Class
final class BalanceViewController: UIViewController{
    
    // MARK: -Define
    
    // MARK: TextField Defined
    var txtFieldUUID: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = NSLocalizedString("UUID", comment: "UUID")
        txtField.borderStyle = .bezel
        return txtField
    }()
    
    
    // MARK: Button Defined
    var btnCheck: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("btnCheck", comment: "Check Button"), for: .normal)
        btn.backgroundColor = .gray
        return btn
    }()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: TextField and Button Added Screen
        txtFieldUUID.txtFieldConstraints(view)
        btnCheck.btnConstraints(view, with: txtFieldUUID)
        
        
    }
}

// MARK: -Constraints
public extension UIView{
    func txtFieldConstraints(_ view: UIView){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
    
    func btnConstraints(_ view: UIView, with txtField: UITextField){
        view.addSubview(self)
        topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 10).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
