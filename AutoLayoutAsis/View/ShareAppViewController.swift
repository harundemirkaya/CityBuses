//
//  ShareAppViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit

// MARK: -Share App Class
class ShareAppViewController: UIViewController {
    
    // MARK: -Define
    
    var btnShare: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle(NSLocalizedString("btnShareApp", comment: "Share App Button"), for: .normal)
        btn.backgroundColor = .gray
        return btn
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: Add Button
        btnShare.btnConstraints(view)
        btnShare.addTarget(self, action: #selector(btnShareClicked), for: .touchUpInside)
    }
    
    @objc func btnShareClicked(){
        let myWebsite = NSURL(string:"https://google.com/")
        let activityViewController = UIActivityViewController(activityItems: [myWebsite!], applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
        
    }
}

public extension UIView{
    func btnShareConstraints(_ view: UIView){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
    }
}
