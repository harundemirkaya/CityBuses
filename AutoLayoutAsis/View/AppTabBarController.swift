//
//  AppTabBarController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit
import Network

// MARK: -App Tab Bar Class
class AppTabBarController: UITabBarController {
    
    var views: [UIViewController] = []
    
    var loadingScreen = LoadingScreen()
    
    let monitor = NWPathMonitor()
    
    var connected = 0
    
    var lblNetworkError: UILabel = {
        var label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .purple
        label.text = "checkNetwork".localized()
        return label
    }()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
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
        views = [homeVC, whereVC, stationsVC]
        
        loadingScreen.startIndicator(view: view)
        tabBar.isHidden = true
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 3){
                    self.connected = 1
                    self.appControl()
                }
            }
        }
        let queue = DispatchQueue(label: "Monitor")
        self.monitor.start(queue: queue)
    }
    
    func appControl(){
        loadingScreen.stopIndicator(view: view)
        tabBar.isHidden = false
        // MARK: TabBar and View Config
        self.viewControllers = views
        tabBar.backgroundColor = .white
        tabBar.tintColor = .purple
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
    // MARK: -Show Alert Message
    func alertMessage(title: String, description: String){
            let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: NSLocalizedString("btnOkey", comment: "Alert Okey Button"), style: UIAlertAction.Style.default)
            alertMessage.addAction(okButton)
            present(alertMessage, animated: true)
    }
}

public extension UIView{
    func error(_ view: UIView){
        view.addSubview(self)
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }
}
