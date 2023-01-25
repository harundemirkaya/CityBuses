//
//  WhereMyBusViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import UIKit

class WhereMyBusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    let tableView = UITableView()
    
    let networkManager = NetworkManager()
    
    var bus: [Vehicle]? {
        didSet{
            tableView.reloadData()
        }
    }
    
    var selectedLatitude: Double?
    var selectedLongitude: Double?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        networkManager.fetchBus{ result in
            self.bus = result.value?.vehicles
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return bus?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + "- " + (bus?[indexPath.row].vehicleID ?? "")
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let busMapVC = BusMapViewController()
        networkManager.fetchBus { result in
            self.selectedLatitude = result.value?.vehicles?[indexPath.row].latitude
            self.selectedLongitude = result.value?.vehicles?[indexPath.row].longitude
        }
        busMapVC.latitude = selectedLatitude
        busMapVC.longitude = selectedLongitude
        if selectedLatitude != nil{
            self.navigationController?.pushViewController(busMapVC, animated: true)
        }
        
    }
    
}
