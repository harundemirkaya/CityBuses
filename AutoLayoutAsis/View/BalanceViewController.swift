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
final class BalanceViewController: UIViewController, NFCTagReaderSessionDelegate{
    
    // MARK: -Define
    
    // MARK: NFC Session Defined
    var session: NFCTagReaderSession?
    var result = ""
    // MARK: TextField Defined
    var txtFieldUUID: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "UUD".localized()
        txtField.layer.cornerRadius = 4.0
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.gray.cgColor
        let paddingViewUsername = UIView(frame: CGRectMake(0, 0, 15, txtField.frame.height))
        txtField.leftView = paddingViewUsername
        txtField.leftViewMode = UITextField.ViewMode.always
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        return txtField
    }()
    
    
    // MARK: Button Defined
    var btnCheck: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("btnBalanceQuery".localized(), for: .normal)
        btn.layer.cornerRadius = 6.0
        btn.backgroundColor = .purple
        return btn
    }()
    
    // MARK: Label Defined
    var lblTitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "balanceQueryTitle".localized()
        label.font = UIFont.boldSystemFont(ofSize: 28.0)
        return label
    }()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: TextField and Button Added Screen
        txtFieldUUID.txtFieldConstraints(view)
        btnCheck.btnConstraints(view, with: txtFieldUUID)
        lblTitle.lblTitleConstraints(view)
        
        btnCheck.addTarget(self, action: #selector(btnTarget), for: UIControl.Event.touchUpInside)
        
    }
    
    @objc func btnTarget(){
        session = NFCTagReaderSession(pollingOption: NFCTagReaderSession.PollingOption.iso14443, delegate: self)
        session?.begin()
    }
    
    func tagReaderSessionDidBecomeActive(_ session: NFCTagReaderSession) {
        
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didInvalidateWithError error: Error) {
        print("Error")
    }
    
    func tagReaderSession(_ session: NFCTagReaderSession, didDetect tags: [NFCTag]) {
        let tag = tags.first!
            session.connect(to: tag, completionHandler: { error in
                if case let .miFare(miFare) = tag {
                    var byteData = [UInt8]()
                    miFare.identifier.withUnsafeBytes { byteData.append(contentsOf: $0) }
                    var uid = "0"
                    byteData.forEach {
                        uid.append(String($0, radix: 16))
                    }
                    print("UID: \(uid)")
                }
            })
    }
}

// MARK: -Constraints
public extension UIView{
    func lblTitleConstraints(_ view: UIView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 65).isActive = true
        centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
    
    func txtFieldConstraints(_ view: UIView){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -30).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func btnConstraints(_ view: UIView, with txtField: UITextField){
        view.addSubview(self)
        topAnchor.constraint(equalTo: txtField.bottomAnchor, constant: 50).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
}

extension String {
    func localized() -> String{
        return NSLocalizedString(self, comment: self)
    }
}
