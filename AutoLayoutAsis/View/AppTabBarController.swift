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
        homeVC.tabBarItem = UITabBarItem.init(title: "Anasayfa", image: UIImage(systemName: "house"), tag: 0)
        let whereVC = UINavigationController(rootViewController: WhereMyBusViewController())
        whereVC.title = "Otobüsüm Nerede?"
        whereVC.tabBarItem = UITabBarItem.init(title: "Otobüsüm Nerede?", image: UIImage(systemName: "bus.fill"), tag: 1)
        let stationsVC = UINavigationController(rootViewController: StationsViewController())
        stationsVC.title = "Duraklar"
        stationsVC.tabBarItem = UITabBarItem.init(title: "Duraklar", image: UIImage(systemName: "mappin.circle"), tag: 3)
        let views: [UIViewController] = [homeVC, whereVC, stationsVC]
        self.viewControllers = views
        tabBar.backgroundColor = .white
    }
    
    
}
