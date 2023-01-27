//
//  myNavigationController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 23.01.2023.
//
// MARK: -Import Libaries
import UIKit

// MARK: -App Navigation Class
class AppNavigationController: UINavigationController {

    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Create Navigate
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backgroundColor = .white
        viewControllers = [AppTabBarController()]
    }
}
