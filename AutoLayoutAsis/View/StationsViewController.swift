//
//  StationsViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import UIKit
import Alamofire

class StationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var stations: [Stop]? {
        didSet{
            for i in 0...(stations?.count ?? 0)-1{
                stationsName.append(stations![i].name!)
            }
            filteredStations = stationsName
            tableView.reloadData()
        }
    }
    
    let tableView = UITableView()
    
    let networkManager = NetworkManager()
    
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    
    let searchController = UISearchController()
    var searchBar: UISearchBar = UISearchBar()
    var stationsName: [String] = []
    var filteredStations: [String] = []
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("stationsPageTitle", comment: "Stations Page Title")
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.addSubview(searchBar)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        
        networkManager.fetchStations { result in
            self.stations = result.value?.stops
        }
        
        filteredStations = stationsName
        
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = NSLocalizedString("searchPlaceholder", comment: "Search Placeholder")
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.sizeToFit()
        
        navigationItem.titleView = pageTitle
        
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.done, target: self, action: #selector(openSearch))
        navigationItem.rightBarButtonItem = searchButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
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
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.titleView = pageTitle
        navigationItem.rightBarButtonItem?.isHidden = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + "- " + (filteredStations[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stationMapVC = StationMapViewController()
        networkManager.fetchStations { result in
            self.selectedLatitude = result.value?.stops?[indexPath.row].latitude
            self.selectedLongitude = result.value?.stops?[indexPath.row].longitude
        }
        stationMapVC.longitude = selectedLongitude
        stationMapVC.latitude = selectedLatitude
        if selectedLatitude != nil{
            self.navigationController?.pushViewController(stationMapVC, animated: true)
        }
    }
    
    // MARK: Search Bar Config
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredStations = []
        if searchText == ""{
            filteredStations = stationsName
        } else{
            for station in stationsName{
                if station.lowercased().contains(searchText.lowercased()){
                    filteredStations.append(station)
                }
            }
        }
        self.tableView.reloadData()
    }
}
