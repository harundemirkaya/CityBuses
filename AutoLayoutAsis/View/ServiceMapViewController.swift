//
//  BusMapViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 25.01.2023.
//
// MARK: -Import Libaries
import UIKit
import MapKit
import CoreLocation

// MARK: Service Map Class
class ServiceMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    // MARK: -Define
    
    // MARK: Map Defined
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    var locationManager: CLLocationManager!
    var routeLatitude: Double?
    var routeLongitude: Double?
    var routes: [Route]?
    var serviceName: String?
    var direction = 0
    var userLatitude: Double?
    var userLongitude: Double?
    var RouteData: Route?
    var routeCoordinates: [CLLocation] = []
    var routeOverlay: MKOverlay?
    var busLocation: [CLLocation] = [] {
        didSet{
            busAnnotation()
        }
    }
    var busID: [String] = []
    
    // MARK: Vehicle Model Defined
    var vehicles: [Vehicle]? {
        didSet{
            filterServiceBus()
        }
    }
    
    // MARK: Network Manager Defined
    var networkManager = NetworkManager()
    
    // MARK: Timer Defined
    var gameTimer: Timer?
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: Map Config
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        mapView.delegate = self
        
        // MARK: MAP
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                switch self.locationManager.authorizationStatus {
                    case .notDetermined, .restricted, .denied:
                    self.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: NSLocalizedString("locationDisabled", comment: "Location Disabled"))
                    case .authorizedAlways, .authorizedWhenInUse:
                        self.locationManager.startUpdatingLocation()
                    @unknown default:
                        break
                }
            } else {
                self.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: NSLocalizedString("errorTitle", comment: "Error"))
            }
        }
        
        // MARK: Map Constraints
        setMapConstrainst()
        
        // MARK: Fetch Bus
        getBus()
        
        // MARK: Set Annotations
        setAnnotation()
        
        // MARK: Draw Route
        drawRoute(routeData: routeCoordinates)
        
        // MARK: Change Direction Button Define and Add Right Bar
        let btnChangeDirection = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(changeDirection))
        navigationItem.rightBarButtonItems = [btnChangeDirection]
        
        // MARK: Refresh Annotations Every 15 Seconds
        Timer.scheduledTimer(timeInterval: 15, target: self, selector: #selector(reload), userInfo: nil, repeats: true)
    }
    
    
    // MARK: -Change Direction Functions
    @objc func changeDirection(){
        let randomRouteLatitude = Double(routes?[direction].points?[2].latitude ?? "0.0")
        let randomRouteLongitude = Double(routes?[direction].points?[2].longitude ?? "0.0")
        let location = CLLocationCoordinate2D(latitude: randomRouteLatitude!, longitude: randomRouteLongitude!)
        let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        if direction + 1 < routes!.count{
            direction += 1
        } else{
            direction = 0
        }
        reload()
    }
    
    @objc func reload(){
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        routeCoordinates.removeAll()
        setAnnotation()
        getBus()
        busAnnotation()
        drawRoute(routeData: routeCoordinates)
    }
    
    // MARK: -Add Stations Annotations
    func setAnnotation(){
        for i in 0...(routes?[direction].points?.count ?? 0)-1{
            routeLatitude = Double(routes?[direction].points?[i].latitude ?? "0.0")
            routeLongitude = Double(routes?[direction].points?[i].longitude ?? "0.0")
            let location = CLLocationCoordinate2D(latitude: routeLatitude!, longitude: routeLongitude!)
            let loc = CLLocation(latitude: routeLatitude!, longitude: routeLongitude!)
            routeCoordinates.append(loc)
            let span = MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            let region = MKCoordinateRegion(center: location, span: span)
            mapView.setRegion(region, animated: true)
            let annotation = MKPointAnnotation()
            annotation.title = routes?[direction].points?[i].stopID
            annotation.coordinate = location
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: -Add Bus Annotations
    func busAnnotation(){
        if !busLocation.isEmpty{
            let annotation = MKPointAnnotation()
            let location = CLLocationCoordinate2D(latitude: (busLocation.last?.coordinate.latitude)!, longitude: (busLocation.last?.coordinate.longitude)!)
            annotation.coordinate = location
            annotation.title = busID.last
            mapView.addAnnotation(annotation)
        }
    }
    
    // MARK: -Map Config
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else{
            annotationView?.annotation = annotation
        }
        for i in 0...(routes?[direction].points?.count ?? 0)-1{
            if(annotation.title == routes?[direction].points?[i].stopID){
                annotationView?.image = UIImage(systemName: "rectangle")
                annotationView?.displayPriority = .defaultHigh
                annotationView?.backgroundColor = .yellow
            }
        }
        let busCount = vehicles?.count ?? 0
        if busCount != 0{
            for i in 0...busCount-1{
                if(annotation.title == vehicles?[i].vehicleID){
                    annotationView?.image = UIImage(systemName: "location")
                    annotationView?.backgroundColor = .white
                }
            }
        }
        return annotationView
    }
    
    // MARK: -User Location Annotation add Map
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        userLatitude = userLocation.coordinate.latitude
        userLongitude = userLocation.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: userLatitude!, longitude: userLongitude!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Me"
        mapView.addAnnotation(annotation)
        
    }

    // MARK: -Map Constraints Function
    func setMapConstrainst(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    // MARK: -Draw Route for Stations Function
    func drawRoute(routeData: [CLLocation]){
        let coordinates = routeData.map { location -> CLLocationCoordinate2D in
            return location.coordinate
        }
        DispatchQueue.main.async {
            self.routeOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(self.routeOverlay!, level: .aboveRoads)
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            self.mapView.setVisibleMapRect(self.routeOverlay!.boundingMapRect, edgePadding: customEdgePadding ,animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKGradientPolylineRenderer(overlay: overlay)
        renderer.setColors([
            .yellow
        ],locations: [])
        renderer.lineCap = .round
        renderer.lineWidth = 3.0
        return renderer
    }
    
    // MARK: -Filter Direction Bus
    func filterServiceBus(){
        let busCount = vehicles?.count ?? 0
        if busCount != 0{
            for i in 0...busCount-1{
                if vehicles?[i].serviceName == serviceName{
                    if vehicles?[i].destination == routes?[direction].destination{
                        let loc = CLLocation(latitude: vehicles![i].latitude ?? 0.0, longitude: vehicles![i].longitude ?? 0.0)
                        busID.append((vehicles?[i].vehicleID!)!)
                        busLocation.append(loc)
                    }
                }
            }
        }
    }
    
    // MARK: -Fetch Bus
    func getBus(){
        networkManager.fetchLiveVehicles { [weak self] result in
            if result.response?.statusCode == 200{
                self?.vehicles = result.value?.vehicles
            } else{
                self?.alertMessage(title: NSLocalizedString("errorTitle", comment: "Error"), description: result.error!.localizedDescription)
            }
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

