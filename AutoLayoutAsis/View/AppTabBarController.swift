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
        homeVC.title = "Anasayfa"
        homeVC.tabBarItem = UITabBarItem.init(title: "Anasayfa", image: UIImage(systemName: ""), tag: 0)
        let whereVC = WhereMyBusViewController()
        whereVC.title = "Otobüsüm Nerede?"
        whereVC.tabBarItem = UITabBarItem.init(title: "Otobüsüm Nerede?", image: UIImage(systemName: ""), tag: 1)
        let stationsVC = StationsViewController()
        stationsVC.title = "Duraklar"
        stationsVC.tabBarItem = UITabBarItem.init(title: "Duraklar", image: UIImage(systemName: ""), tag: 3)
        let views: [UIViewController] = [homeVC, whereVC, stationsVC]
        self.viewControllers = views
        self.tabBarController?.tabBar.tintColor = .white
    }
    
    
}
