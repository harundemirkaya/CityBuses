//
//  HowIGoViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 14.02.2023.
//
// MARK: -Import Libaries
import UIKit
import GoogleMaps
import CoreLocation
import MapKit

// MARK: -HowIGoViewController Class
class HowIGoViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {

    // MARK: -Define
    
    // MARK: Google API Key
    let apiKey = "AIzaSyCz2sMTWc0JCu5ztPLWkYQY5RddxKBXdv8"
    
    // MARK: Map Defined
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    // MARK: Location Manager Defined
    var locationManager = CLLocationManager()
    
    // MARK: Annotation Counter
    var annotationCounter = 0
    var coordinateFrom = CLLocationCoordinate2D()
    var coordinateTo = CLLocationCoordinate2D()
    
    var fromPlaceID: String? {
        didSet{
            controlPlaceID()
        }
    }
    
    var toPlaceID: String?{
        didSet{
            controlPlaceID()
        }
    }
    
    var networkManager = NetworkManager()
    
    var routeMaps: RouteMaps? {
        didSet{
            if routeMaps?.routes.count != nil{
                pushScreen()
            }
        }
    }
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: -Screen
        view.backgroundColor = .white
        
        // MARK: Set Constraints
        mapView.mapConstraints(view)
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        DispatchQueue.global().async {
            if CLLocationManager.locationServicesEnabled() {
                self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
                self.locationManager.startUpdatingLocation()
                self.locationManager.stopUpdatingLocation()
            }
        }
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        mapView.addGestureRecognizer(longPressRecognizer)
    }
    
    @objc func handleLongPress(sender: UILongPressGestureRecognizer){
        if sender.state != .began {
            return
        }
        if annotationCounter != 2{
            let touchPoint = sender.location(in: mapView)
            let coordinate = mapView.convert(touchPoint, toCoordinateFrom: mapView)
            if annotationCounter == 0{
                coordinateFrom.latitude = coordinate.latitude
                coordinateFrom.longitude = coordinate.longitude
            } else if annotationCounter == 1{
                coordinateTo.latitude = coordinate.latitude
                coordinateTo.longitude = coordinate.longitude
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            annotationCounter += 1
        } else{
            convertCoordinatesToPlaceID(latitude: coordinateFrom.latitude, longitude: coordinateFrom.longitude) { (placeID) in
                if let placeID = placeID {
                    self.fromPlaceID = placeID
                }
            }
            convertCoordinatesToPlaceID(latitude: 41.004609, longitude: 28.720101) { (placeID) in
                if let placeID = placeID {
                    self.toPlaceID = placeID
                }
            }
        }
    }
    
    func controlPlaceID(){
        if fromPlaceID != nil, toPlaceID != nil{
            print(fromPlaceID)
            print(toPlaceID)
            getDirections(from: fromPlaceID!, to: toPlaceID!)
        }
    }
    
    func getDirections(from: String, to: String) {
        let origin = "place_id:\(from)"
        let destination = "place_id:\(to)"
        
        networkManager.apiKey = apiKey
        networkManager.origin = origin
        networkManager.destination = destination
        networkManager.feetchRouteMaps { result in
            self.routeMaps = result.value
        }
        
    }
    
    func convertCoordinatesToPlaceID(latitude: Double, longitude: Double, completion: @escaping (String?) -> Void) {
        let urlString = "https://maps.googleapis.com/maps/api/geocode/json?key=\(apiKey)&latlng=\(latitude),\(longitude)&language=tr&region=tr"
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                if let results = json?["results"] as? [[String: Any]], let placeID = results.first?["place_id"] as? String {
                    completion(placeID)
                }
            } catch {
                completion(nil)
            }
        }
        task.resume()
    }
    
    func pushScreen(){
        
    }
}

public extension UIView{
    func mapConstraints(_ view: UIView){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
