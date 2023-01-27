//
//  HomeViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 23.01.2023.
//
// MARK: -Import Libaries
import UIKit
import MapKit
import CoreLocation
import Firebase

// MARK: -Home Class
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    // MARK: -Define
    
    // MARK: Map Defined
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    var locationManager: CLLocationManager!
    var latitude: Double?
    var longitude: Double?
    
    
    // MARK: SideBar Defined
    var isSlideMenuPresented = false
    
    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.30
    
    lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "square.grid.3x3.middle.filled")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuBarButtonItemTapped))
    
    lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .white
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        return view
    }()
    var menuCount = 7
    
    // MARK: Map Page Defined
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        return view
    }()
    
    // MARK: SideBar Menu Defined
    let tableView = UITableView()
    var menuItem = [
        NSLocalizedString("whereMyBusMenuItem", comment: "Where My Bus Menu Item"),
        NSLocalizedString("stationsMenuItem", comment: "Stations Menu Item"),
        NSLocalizedString("dealersMenuItem", comment: "Dealers Menu Item"),
        NSLocalizedString("balanceQueryMenuItem", comment: "Balance Query Menu Item"),
        NSLocalizedString("shareAppMenuItem", comment: "Share App Menu Item"),
        NSLocalizedString("changeLanguageMenuItem", comment: "Change Language Menu Item"),
        NSLocalizedString("settingsMenuItem", comment: "Setting Menu Item")
        ]
    var menuItems = [MenuItems]()
    var selectedItem: Int?
    
    // MARK: User Defined
    let currentUser = Auth.auth().currentUser
    
    // MARK: Page Title Defined
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("homePageTitle", comment: "Home Page Title")
        return label
    }
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        navigationItem.titleView = pageTitle
        
        // MARK: Session Control
        if currentUser != nil{
            menuItem.append(NSLocalizedString("signOutMenuItem", comment: "Sign Out Menu Item"))
        } else{
            menuItem.removeLast()
            menuItem.append(NSLocalizedString("signInSignUpMenuItem", comment: "Sign In Sign Up Menu Item"))
            menuCount -= 1
        }
        
        // MARK: Menu
        menuBarButtonItem.tintColor = .white
        navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        setMenuItems()
        
        // MARK: Map Page
        menuView.pinMenuTo(view, with: slideInMenuPadding)
        containerView.edgeTo(view)
        setMapConstrainst()
    }
    
    // MARK: -Table Frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: -Sidebar Menu Config
    @objc func menuBarButtonItemTapped(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.containerView.frame.origin.x = self.isSlideMenuPresented ? 0 : self.containerView.frame.width - self.slideInMenuPadding
        } completion: { (finished) in
            self.isSlideMenuPresented.toggle()
        }
    }
    
    func setMenuItems(){
        for i in 0...menuCount{
            let item = MenuItems(id: i, name: menuItem[i])
            menuItems.append(item)
        }
    }
    
    // MARK: TableView for Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return menuItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row].name
        return cell
    }
    
    // MARK: -TableView Select Row
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedItem = menuItems[indexPath.row].id
        if selectedItem == 0{
            tabBarController?.selectedIndex = 1
        } else if selectedItem == 1{
            tabBarController?.selectedIndex = 2
        } else if selectedItem == 2{
            let dealersVC = DealersViewController()
            self.navigationController?.pushViewController(dealersVC, animated: true)
        } else if selectedItem == 3{
            let balanceVC = BalanceViewController()
            self.navigationController?.pushViewController(balanceVC, animated: true)
        } else if selectedItem == 4{
            let shareAppVC = ShareAppViewController()
            self.navigationController?.pushViewController(shareAppVC, animated: true)
        } else if selectedItem == 5{
            let changeLanguageVC = ChangeLanguageViewController()
            self.navigationController?.pushViewController(changeLanguageVC, animated: true)
        } else if selectedItem == 6 && menuCount == 7{
            let settingsVC = SettingsViewController()
            self.navigationController?.pushViewController(settingsVC, animated: true)
        } else if selectedItem == 7 && menuCount == 7 || selectedItem == 6 && menuCount == 6{
            if currentUser != nil{
                do{
                    try Auth.auth().signOut()
                    let homeVC = HomeViewController()
                    self.navigationController?.pushViewController(homeVC, animated: true)
                } catch{
                    print("Error")
                }
            } else{
                let loginVC = LoginViewController()
                self.navigationController?.pushViewController(loginVC, animated: true)
            }
        }
    }
    
    // MARK: -Map Config
    func setMapConstrainst(){
        containerView.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: containerView.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor).isActive = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        latitude = userLocation.coordinate.latitude
        longitude = userLocation.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
}

// MARK: Constraints
public extension UIView {
    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
