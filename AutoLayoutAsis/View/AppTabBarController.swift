//
//  AppTabBarController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import UIKit

class AppTabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem.init(title: NSLocalizedString("tabBarHome", comment: "Tab Bar Home Page"), image: UIImage(systemName: "house"), tag: 0)
        
        let whereVC = UINavigationController(rootViewController: WhereMyBusViewController())
        whereVC.tabBarItem = UITabBarItem.init(title: NSLocalizedString("tabBarWhereMyBus", comment: "Tab Bar Where My Bus Page"), image: UIImage(systemName: "bus.fill"), tag: 1)
        
        let stationsVC = UINavigationController(rootViewController: StationsViewController())
        stationsVC.tabBarItem = UITabBarItem.init(title: NSLocalizedString("tabBarStations", comment: "Tab Bar Stations Page"), image: UIImage(systemName: "mappin.circle"), tag: 3)
        let views: [UIViewController] = [homeVC, whereVC, stationsVC]
        self.viewControllers = views
        tabBar.backgroundColor = .white
    }
    
    
}
