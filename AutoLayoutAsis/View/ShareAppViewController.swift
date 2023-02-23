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
    
    // MARK: Button Defined
    var btnShare: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("btnShareApp".localized(), for: .normal)
        btn.isAccessibilityElement = true
        btn.accessibilityHint = "btnShareApp".localized()
        btn.layer.cornerRadius = 6.0
        btn.backgroundColor = .purple
        return btn
    }()

    // MARK: Title Label Defined
    var lblTitle: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: 200, height: 21))
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .left
        label.text = "shareAppTitle".localized()
        label.isAccessibilityElement = true
        label.accessibilityHint = "shareAppTitle".localized()
        label.font = UIFont.boldSystemFont(ofSize: 28.0)
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: Add Button
        btnShare.btnShareConstraints(view)
        lblTitle.lblTitle(view)
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
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalToConstant: view.frame.size.width * 0.85).isActive = true
    }
}
