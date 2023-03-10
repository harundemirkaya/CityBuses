//
//  HomeViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 23.01.2023.
//
// MARK: -Import Libraries
import UIKit
import MapKit
import CoreLocation
import Firebase
import FirebaseRemoteConfig

// MARK: -Home Class
class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate{
    
    // MARK: -Define
    
    // MARK: -FirebaseRemoteConfig Example Variable
    var message = ""
    
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
    
    lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "line.3.horizontal")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuBarButtonItemTapped))
    
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
    var menuCount = 8
    
    // MARK: Map Page Defined
    lazy var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled(){
                self.locationManager.startUpdatingLocation()
            }
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
        NSLocalizedString("settingsMenuItem", comment: "Setting Menu Item"),
        NSLocalizedString("howCanIgoMenuItems", comment: "How Can I Go Menu Item")
        ]
    var menuItems = [MenuItems]()
    var selectedItem: Int?
    
    // MARK: User Defined
    let currentUser = Auth.auth().currentUser
    
    // MARK: Page Title Defined
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = "homePageTitle".localized()
        return label
    }
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: Screen
        view.backgroundColor = .white
        
        NotificationCenter.default.addObserver(self, selector: #selector(notificationReceive), name: Notification.Name("notificationCalled"), object: nil)
        
        navigationItem.titleView = pageTitle
        
        // MARK: Session Control
        if currentUser != nil{
            menuItem.append(NSLocalizedString("signOutMenuItem", comment: "Sign Out Menu Item"))
        } else{
            menuItem.append(NSLocalizedString("signInSignUpMenuItem", comment: "Sign In Sign Up Menu Item"))
        }
        
        // MARK: Menu
        menuBarButtonItem.tintColor = .white
        navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        setMenuItems()
        
        // MARK: Map Page
        menuView.pinMenuTo(view, with: slideInMenuPadding)
        containerView.edgeTo(view)
        setMapConstrainst()
        
        Task{
            try await startFetching()
        }
    }
    
    @objc func notificationReceive(){
        let stationMapVC = StationMapViewController()
        navigationController?.pushViewController(stationMapVC, animated: true)
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
        cell.textLabel?.isAccessibilityElement = true
        cell.textLabel?.accessibilityHint = menuItems[indexPath.row].name
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
        } else if selectedItem == 6 && menuCount == 8{
            let settingsVC = SettingsViewController()
            self.navigationController?.pushViewController(settingsVC, animated: true)
        } else if selectedItem == 7{
            let howCanIgoVC = HowIGoViewController()
            self.navigationController?.pushViewController(howCanIgoVC, animated: true)
        } else if selectedItem == 8 && menuCount == 8 || selectedItem == 6 && menuCount == 6{
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
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
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
    
    // MARK: -Show Alert Message
    func alertMessage(title: String, description: String){
        let alertMessage = UIAlertController(title: title, message: description, preferredStyle: UIAlertController.Style.alert)
        let okButton = UIAlertAction(title: NSLocalizedString("btnOkey", comment: "Alert Okey Button"), style: UIAlertAction.Style.default)
        alertMessage.addAction(okButton)
        alertMessage.isAccessibilityElement = true
        alertMessage.accessibilityHint = description
        self.present(alertMessage, animated: true)
    }
    
    private func startFetching() async throws {
        let rc = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        rc.configSettings = settings
        
        do {
            let config = try await rc.fetchAndActivate()
            switch config {
            case .successFetchedFromRemote:
                self.message = rc.configValue(forKey: "fetchRemoteConfig").stringValue ?? "Failed"
                print(self.message)
                return
            case .successUsingPreFetchedData:
                self.message = rc.configValue(forKey: "fetchRemoteConfig").stringValue ?? "Failed"
                print(self.message)
                return
            default:
                print("Error activating")
                return
            }
        } catch let error {
            print("Error fetching: \(error.localizedDescription)")
        }
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
