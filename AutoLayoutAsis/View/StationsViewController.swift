//
//  StationsViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import UIKit
import Alamofire

class StationsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var stations: [Stop]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    let tableView = UITableView()
    
    let networkManager = NetworkManager()
    
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        networkManager.fetchStations { result in
            self.stations = result.value?.stops
        }
       
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return stations?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + "- " + (stations?[indexPath.row].name ?? "")
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
        print(selectedLatitude)
        if selectedLatitude != nil{
            self.navigationController?.pushViewController(stationMapVC, animated: true)
            
        }
    }
}
