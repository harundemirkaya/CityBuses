//
//  WhereMyBusViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import UIKit
import Alamofire

class WhereMyBusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    let tableView = UITableView()
    
    var services: [Service]? {
        didSet{
            for i in 0...(services?.count ?? 0)-1{
                servicesName.append(services![i].name!)
            }
            filteredServices = servicesName
            tableView.reloadData()
        }
    }
    
    let networkManager = NetworkManager()
    
    var selectedRoute: [Route]?
    var selectedServiceName: String?
    
    let searchController = UISearchController()
    var searchBar: UISearchBar = UISearchBar()
    var filteredServices: [String] = []
    var servicesName: [String] = []
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = "Where My Bus?"
        return label
    }
    
    
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
        
        filteredServices = servicesName
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = "Search"
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        
        navigationItem.titleView = pageTitle
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.done, target: self, action: #selector(openSearch))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    @objc func openSearch(){
        view.addSubview(searchBar)
        UIView.animate(withDuration: 0.5) {
            self.searchBar.frame = CGRect(x:0, y:0, width:300, height:20)
        }
        navigationItem.titleView = searchBar
        searchBar.showsCancelButton = true
        navigationItem.rightBarButtonItem?.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = pageTitle
        navigationItem.rightBarButtonItem?.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = filteredServices[indexPath.row]
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
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredServices = []
        if searchText == ""{
            filteredServices = servicesName
        } else{
            for station in servicesName{
                if station.lowercased().contains(searchText.lowercased()){
                    filteredServices.append(station)
                }
            }
        }
        self.tableView.reloadData()
    }
}
