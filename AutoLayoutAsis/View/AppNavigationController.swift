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
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        navigationBar.standardAppearance = appearance;
        navigationBar.scrollEdgeAppearance = navigationBar.standardAppearance
        
        viewControllers = [AppTabBarController()]
        
    }
    

}
