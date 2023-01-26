//
//  myNavigationController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 23.01.2023.
//

import UIKit

class AppNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backgroundColor = .white
        
        viewControllers = [AppTabBarController()]
    }
}
