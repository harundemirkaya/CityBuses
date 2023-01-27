//
//  StationsViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit
import Alamofire

// MARK: -Stations Class
class StationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: -DEFINE
    
    // MARK: Table Defined
    private lazy var tableView : UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        return table
    }()
    
    // MARK: Stop Model Defined
    var stations: [Stop]? {
        didSet{
            for i in 0...(stations?.count ?? 0)-1{
                stationsName.append(stations![i].name!)
            }
            filteredStations = stationsName
            tableView.reloadData()
        }
    }
    
    // MARK: Network Manager Defined
    let networkManager = NetworkManager()
    
    // MARK: Table Tools Defined
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    var stationsName: [String] = []
    var filteredStations: [String] = []
    
    // MARK: Search Bar Defined
    let searchController = UISearchController()
    var searchBar: UISearchBar = UISearchBar()
   
    // MARK: Page Title Defined
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("stationsPageTitle", comment: "Stations Page Title")
        return label
    }
    
    // MARK: -View Did Load
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Screen
        self.view.backgroundColor = .white
        navigationItem.titleView = pageTitle
        
        // MARK: TableView and Search Bar
        view.addSubview(tableView)
        tableView.addSubview(searchBar)
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = NSLocalizedString("searchPlaceholder", comment: "Search Placeholder")
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.sizeToFit()
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.done, target: self, action: #selector(openSearch))
        navigationItem.rightBarButtonItem = searchButton
        
        // MARK: Stations
        getStations()
        filteredStations = stationsName
    }
    
    // MARK: -Fetch Stations
    func getStations(){
        networkManager.fetchStations { [weak self] result in
            self?.stations = result.value?.stops
        }
    }
    
    // MARK: -Search Bar Open Keyboard
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.async {
            self.searchController.searchBar.becomeFirstResponder()
        }
    }
    
    // MARK: -Search Bar Functions
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
    
    // MARK: -TableView Frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: -TableView for Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + "- " + (filteredStations[indexPath.row])
        return cell
    }
    
    // MARK: -TableView Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let stationMapVC = StationMapViewController()
        networkManager.fetchStations { [weak self] result in
            self?.selectedLatitude = result.value?.stops?[indexPath.row].latitude
            self?.selectedLongitude = result.value?.stops?[indexPath.row].longitude
        }
        stationMapVC.longitude = selectedLongitude
        stationMapVC.latitude = selectedLatitude
        if selectedLatitude != nil{
            self.navigationController?.pushViewController(stationMapVC, animated: true)
        }
    }
}
