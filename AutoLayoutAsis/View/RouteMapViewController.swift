//
//  RouteMapViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 15.02.2023.
//
// MARK: -Import Libaries
import UIKit
import CoreLocation
import MapKit

// MARK: -RouteMapViewController Class
class RouteMapViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate{
    // MARK: -Define
    
    // MARK: Route Defined
    var route: [Step]?
    
    // MARK: Map Defined
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    // MARK: Location Manager Defined
    var locationManager = CLLocationManager()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: -Screen
        view.backgroundColor = .white
        
        // MARK: -Map Config
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
        
    }
}
