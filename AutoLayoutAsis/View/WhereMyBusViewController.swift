//
//  WhereMyBusViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit
import Alamofire

// MARK: -Where My Bus Class
class WhereMyBusViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    // MARK: -DEFINE
    
    // MARK: TableView Defined
    private lazy var tableView : UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        return table
    }()
    
    // MARK: Service Model Defined
    var services: [Service]? {
        didSet{
            for i in 0...(services?.count ?? 0)-1{
                servicesName.append(services![i].name!)
            }
            filteredServices = servicesName
            tableView.reloadData()
        }
    }
    
    // MARK: Network Manager Defined
    let networkManager = NetworkManager()
    
    // MARK: Table Tools Defined
    var selectedRoute: [Route]?
    var selectedServiceName: String?
    var filteredServices: [String] = []
    var servicesName: [String] = []
    
    // MARK: Search Bar Defined
    let searchController = UISearchController()
    var searchBar: UISearchBar = UISearchBar()
    
    // MARK: Page Title Defined
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("whereMyBusPageTitle", comment: "Where My Bus Page Title")
        return label
    }
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Screen
        view.backgroundColor = .white
        navigationItem.titleView = pageTitle
        
        // MARK: TableView and SearchBar
        view.addSubview(tableView)
        searchBar.searchBarStyle = UISearchBar.Style.prominent
        searchBar.placeholder = NSLocalizedString("searchPlaceholder", comment: "Search Placeholder")
        searchBar.sizeToFit()
        searchBar.isTranslucent = false
        searchBar.backgroundImage = UIImage()
        searchBar.delegate = self
        searchBar.sizeToFit()
        let searchButton = UIBarButtonItem(image: UIImage(systemName: "magnifyingglass"), style: UIBarButtonItem.Style.done, target: self, action: #selector(openSearch))
        navigationItem.rightBarButtonItem = searchButton
        
        // MARK: Services
        getServices()
        filteredServices = servicesName
    }
    
    // MARK: -Fetch Services
    func getServices(){
        networkManager.fetchServices{ [weak self] result in
            if result.response?.statusCode == 200{
                self?.services = result.value?.services
            } else{
                self?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
            
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
    
    // MARK: -TableView Frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: -TableView for Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredServices.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = filteredServices[indexPath.row]
        return cell
    }
    
    // MARK: -TableView Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let serviceMapVC = ServiceMapViewController()
        networkManager.fetchServices { [weak self] result in
            self?.selectedRoute = result.value?.services?[indexPath.row].routes
            self?.selectedServiceName = result.value?.services?[indexPath.row].name
        }
        serviceMapVC.routes = selectedRoute
        serviceMapVC.serviceName = selectedServiceName
        if selectedRoute != nil{
            self.navigationController?.pushViewController(serviceMapVC, animated: true)
        }
    }
    
    // MARK: -Show Alert Message
    func alertMessage(title: String, description: String){
            let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
            let okButton = UIAlertAction(title: NSLocalizedString("btnOkey", comment: "Alert Okey Button"), style: UIAlertAction.Style.default)
            alertMessage.addAction(okButton)
            self.present(alertMessage, animated: true)
    }
}
