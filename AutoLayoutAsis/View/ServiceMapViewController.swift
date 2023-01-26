//
//  BusMapViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 25.01.2023.
//

import UIKit
import MapKit
import CoreLocation

class ServiceMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
    
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    var locationManager: CLLocationManager!
    var routes: [Route]?
    var serviceName: String?
    var routeLatitude: Double?
    var routeLongitude: Double?
    var vehicles: [Vehicle]? {
        didSet{
            filterServiceBus()
        }
    }
    
    var direction = 0
    var userLatitude: Double?
    var userLongitude: Double?
    var busLocation: [CLLocation] = [] {
        didSet{
            busAnnotation()
        }
    }
    var busID: [String] = []
    
    var RouteData: Route?
    var routeCoordinates: [CLLocation] = []
    var routeOverlay: MKOverlay?
    
    var networkManager = NetworkManager()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        mapView.delegate = self
        if CLLocationManager.locationServicesEnabled(){
            locationManager.startUpdatingLocation()
        }
        setMapConstrainst()
        getBus()
        setAnnotation()
        drawRoute(routeData: routeCoordinates)
        
        let btnChangeDirection = UIBarButtonItem(barButtonSystemItem: .reply, target: self, action: #selector(changeDirection))
        navigationItem.rightBarButtonItems = [btnChangeDirection]
        
    }
    
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
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        routeCoordinates.removeAll()
        setAnnotation()
        busAnnotation()
        drawRoute(routeData: routeCoordinates)
        getBus()
        
    }
    
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
    
    func busAnnotation(){
        let annotation = MKPointAnnotation()
        let location = CLLocationCoordinate2D(latitude: (busLocation.last?.coordinate.latitude)!, longitude: (busLocation.last?.coordinate.longitude)!)
        annotation.coordinate = location
        annotation.title = busID.last
        mapView.addAnnotation(annotation)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else{
            annotationView?.annotation = annotation
        }
        for i in 0...(routes?[direction].points?.count ?? 0)-1{
            if(annotation.title == routes?[direction].points?[i].stopID){
                annotationView?.image = UIImage(systemName: "rectangle.roundedbottom.fill")
                annotationView?.displayPriority = .defaultHigh
            }
        }
        
        var busCount = vehicles?.count ?? 0
        if busCount == 0{
            busCount = 1
        }
        for i in 0...(busCount-1){
            if(annotation.title == vehicles?[i].vehicleID){
                annotationView?.image = UIImage(systemName: "bus")
            }
        }
        return annotationView
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0] as CLLocation
        userLatitude = userLocation.coordinate.latitude
        userLongitude = userLocation.coordinate.longitude
        let location = CLLocationCoordinate2D(latitude: userLatitude!, longitude: userLongitude!)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        annotation.title = "Ben"
        mapView.addAnnotation(annotation)
        
    }

    func setMapConstrainst(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
    
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
    
    func filterServiceBus(){
        var busCount = vehicles?.count ?? 0
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
    
    func getBus(){
        networkManager.fetchLiveVehicles { result in
            self.vehicles = result.value?.vehicles
        }
    }
}
