//
//  WhereMyBusViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import UIKit
import Alamofire

class WhereMyBusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let tableView = UITableView()
    
    var services: [Service]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    let networkManager = NetworkManager()
    
    var selectedRoute: [Route]?
    var selectedServiceName: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        
        networkManager.fetchServices{ result in
            self.services = result.value?.services
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return services?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + "- " + (services?[indexPath.row].description ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceMapVC = ServiceMapViewController()
        networkManager.fetchServices { result in
            self.selectedRoute = result.value?.services?[indexPath.row].routes
            self.selectedServiceName = result.value?.services?[indexPath.row].name
        }
        serviceMapVC.routes = selectedRoute
        serviceMapVC.serviceName = selectedServiceName
        if selectedRoute != nil{
            self.navigationController?.pushViewController(serviceMapVC, animated: true)
        }
    }
}
