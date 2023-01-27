//
//  StationMapViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 25.01.2023.
//
// MARK: -Import Libaries
import UIKit
import MapKit
import CoreLocation

// MARK: -Station Map Class
class StationMapViewController: UIViewController {
    
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
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Set Constraints and Annotation
        setMapConstrainst()
        setAnnotation()
    }
    
    // MARK: -Set Annotation Function
    func setAnnotation(){
        let location = CLLocationCoordinate2D(latitude: latitude ?? 0.0, longitude: longitude ?? 0.0)
        let span = MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
    }
    
    // MARK: -Map Constraints
    func setMapConstrainst(){
        view.addSubview(mapView)
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
    }
}
