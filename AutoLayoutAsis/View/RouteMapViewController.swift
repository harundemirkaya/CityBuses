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
    
    var routeOverlay: MKOverlay?
    
    var coordinates = [CLLocationCoordinate2D]()
    
    // MARK: Bottom Sheet Defined
    let bottomSheetVC = BottomSheetViewController()
    var initialTouchPoint: CGPoint = CGPoint.zero
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        // MARK: -Screen
        view.backgroundColor = .white
        
        // MARK: -Map Config
        mapView.mapConstraints(view)
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
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
        
        // MARK: Draw Polyline
        drawRouteOnMap(route: route!)
        
        // MARK: Bottom Sheet
        let bottomSheetVC = BottomSheetViewController()
        bottomSheetVC.route = self.route
        if let sheet = bottomSheetVC.sheetPresentationController{
            sheet.detents = [.medium(), .large()]
            sheet.prefersScrollingExpandsWhenScrolledToEdge = false
            sheet.prefersGrabberVisible = true
            sheet.preferredCornerRadius = 24
            sheet.largestUndimmedDetentIdentifier = .medium
        }
        self.present(bottomSheetVC, animated: true)
    }
    
    func drawRouteOnMap(route: [Step]) {
        for step in route {
            var latitude = step.startLocation.lat
            var longitude = step.startLocation.lng
            coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
            latitude = step.endLocation.lat
            longitude = step.endLocation.lng
            coordinates.append(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
        }
        DispatchQueue.main.async {
            self.routeOverlay = MKPolyline(coordinates: self.coordinates, count: self.coordinates.count)
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
    
    override func viewWillDisappear(_ animated: Bool) {
        bottomSheetVC.dismiss(animated: true, completion: nil)
    }
}
