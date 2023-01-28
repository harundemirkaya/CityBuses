//
//  AppTabBarController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit

// MARK: -App Tab Bar Class
class AppTabBarController: UITabBarController {
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: -Navigation Bar Style
        UINavigationBar.appearance().barTintColor = .white
        UINavigationBar.appearance().tintColor = .black
        UINavigationBar.appearance().backgroundColor = .white
        
        // MARK: Define VC and Add Tab Bar
        let homeVC = UINavigationController(rootViewController: HomeViewController())
        homeVC.tabBarItem = UITabBarItem.init(title: NSLocalizedString("tabBarHome", comment: "Tab Bar Home Page"), image: UIImage(systemName: "house"), tag: 0)
        
        let whereVC = UINavigationController(rootViewController: WhereMyBusViewController())
        whereVC.tabBarItem = UITabBarItem.init(title: NSLocalizedString("tabBarWhereMyBus", comment: "Tab Bar Where My Bus Page"), image: UIImage(systemName: "bus.fill"), tag: 1)
        
        let stationsVC = UINavigationController(rootViewController: StationsViewController())
        stationsVC.tabBarItem = UITabBarItem.init(title: NSLocalizedString("tabBarStations", comment: "Tab Bar Stations Page"), image: UIImage(systemName: "mappin.circle"), tag: 3)
        let views: [UIViewController] = [homeVC, whereVC, stationsVC]
        
        // MARK: TabBar and View Config
        self.viewControllers = views
        tabBar.backgroundColor = .white
    }
}
