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
class HowIGoViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource {

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
    
    var routeMaps: RouteMaps? {
        didSet{
            if routeMaps?.routes.count != nil{
                pushScreen()
            }
        }
    }
    
    var btnClear: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .purple
        btn.setTitle("clear".localized(), for: UIControl.State.normal)
        btn.isAccessibilityElement = true
        btn.accessibilityHint = "clear".localized()
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    var btnDirection: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .purple
        btn.setTitle("directions".localized(), for: UIControl.State.normal)
        btn.isAccessibilityElement = true
        btn.accessibilityHint = "directions".localized()
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    // MARK: TextField Defined
    var txtFieldFrom: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "from".localized()
        txtField.isAccessibilityElement = true
        txtField.accessibilityHint = "from".localized()
        txtField.layer.cornerRadius = 4.0
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.gray.cgColor
        let paddingViewUsername = UIView(frame: CGRectMake(0, 0, 15, txtField.frame.height))
        txtField.leftView = paddingViewUsername
        txtField.leftViewMode = UITextField.ViewMode.always
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        return txtField
    }()
        
    var txtFieldTo: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "to".localized()
        txtField.isAccessibilityElement = true
        txtField.accessibilityHint = "to".localized()
        txtField.layer.cornerRadius = 4.0
        txtField.layer.borderWidth = 1.0
        txtField.layer.borderColor = UIColor.gray.cgColor
        let paddingViewUsername = UIView(frame: CGRectMake(0, 0, 15, txtField.frame.height))
        txtField.leftView = paddingViewUsername
        txtField.leftViewMode = UITextField.ViewMode.always
        txtField.autocorrectionType = .no
        txtField.autocapitalizationType = .none
        return txtField
    }()
    
    // MARK: StationsView Defined
    var stationsView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    // MARK: TableViews Defined
    private lazy var tableViewFrom : UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        return table
    }()
        
    private lazy var tableViewTo : UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.backgroundColor = .white
        table.translatesAutoresizingMaskIntoConstraints = false
        table.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        return table
    }()
    
    // MARK: Stations Data
    var stations: [Stop]? {
        didSet{
            if stations!.count != 0 {
                filteredStations = stations!
            }
            tableViewFrom.reloadData()
            tableViewTo.reloadData()
        }
    }
    var filteredStations: [Stop] = []
    
    // MARK: StackView
    var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fill
        stackView.spacing = 10
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    // MARK: Close Keyboard Button
    var btnCloseKeyboard: UIButton = {
        let btn = UIButton()
        btn.setTitle("closeKeyboard".localized(), for: UIControl.State.normal)
        btn.isAccessibilityElement = true
        btn.accessibilityHint = "closeKeyboard".localized()
        btn.setTitleColor(.black, for: UIControl.State.normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .white
        return btn
    }()
    
    var fromID = 0
    var toID = 0
    
    // MARK: From and To Location
    var fromLocation: CLLocation = CLLocation(latitude: 0, longitude: 0){
        didSet{
            if !stations!.isEmpty{
                for i in 0...stations!.count-1{
                    if stations![i].latitude == fromLocation.coordinate.latitude, stations![i].longitude == fromLocation.coordinate.longitude{
                        fromID = stations![i].stopID!
                    }
                }
            }
        }
    }
    var toLocation: CLLocation = CLLocation(latitude: 0, longitude: 0){
        didSet{
            if !stations!.isEmpty{
                for i in 0...stations!.count-1{
                    if stations![i].latitude == toLocation.coordinate.latitude, stations![i].longitude == toLocation.coordinate.longitude{
                        toID = stations![i].stopID!
                    }
                }
            }
        }
    }
    
    var rememberClear = 0
    var rememberDirection = 0
    
    let loadingScreen = LoadingScreen()
    
    let howIGoViewModel = HowIGoViewModel()
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: Get Stations
        howIGoViewModel.howIGoVC = self
        howIGoViewModel.getStations()
        
        // MARK: Set Station View Constraints
        stationsView.stationsViewConstraints(view)
        txtFieldFrom.txtFieldFromConstraints(stationsView)
        txtFieldTo.txtFieldToConstraints(stationsView, txtFieldFrom: txtFieldFrom)
        stackView.stackViewConstraints(view, stationsView: stationsView)
        
        // MARK: Map Config
        mapView.setMapConstraints(stackView)
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
        
        // MARK: TextFields
        tableViewFrom.tableViewConstraints(stackView)
        tableViewTo.tableViewConstraints(stackView)
        tableViewFrom.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        tableViewTo.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        txtFieldFrom.addTarget(self, action: #selector(txtFieldStartTableFrom), for: .editingDidBegin)
        txtFieldTo.addTarget(self, action: #selector(txtFieldStartTableTo), for: .editingDidBegin)
        
        txtFieldFrom.inputAccessoryView = btnCloseKeyboard
        txtFieldTo.inputAccessoryView = btnCloseKeyboard
        btnCloseKeyboard.addTarget(self, action: #selector(closeKeyboard), for: .touchUpInside)
            
        // MARK: Search Algorithm
        txtFieldFrom.addTarget(self, action: #selector(textFieldFromDidChange), for: .editingChanged)
        txtFieldTo.addTarget(self, action: #selector(textFieldToDidChange), for: .editingChanged)
        
        let longPressRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress))
        mapView.addGestureRecognizer(longPressRecognizer)
        
        // MARK: Buttons
        btnClear.btnClearConstraints(view, mapView: mapView)
        btnClear.addTarget(self, action: #selector(btnClearTarget), for: .touchUpInside)
        btnDirection.btnDirectionConstraints(view, mapView: mapView)
        btnDirection.addTarget(self, action: #selector(btnDirectionTarget), for: .touchUpInside)
        btnDirection.isHidden = true
        btnClear.isHidden = true
    }
    
    @objc func btnClearTarget(){
        btnDirection.isHidden = true
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        annotationCounter = 0
        txtFieldFrom.text = ""
        txtFieldTo.text = ""
        btnClear.isHidden = true
    }
    
    @objc func btnDirectionTarget(){
        howIGoViewModel.getPlaceID(apiKey: apiKey, latitude: coordinateFrom.latitude, longitude: coordinateFrom.longitude, fromOrTo: 0)
        howIGoViewModel.getPlaceID(apiKey: apiKey, latitude: coordinateTo.latitude, longitude: coordinateTo.longitude, fromOrTo: 1)
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
                btnClear.isHidden = false
                txtFieldFrom.text = "\(String(format: "%.3f", coordinateFrom.latitude)) - \(String(format: "%.3f", coordinateFrom.longitude))"
            } else if annotationCounter == 1{
                coordinateTo.latitude = coordinate.latitude
                coordinateTo.longitude = coordinate.longitude
                btnDirection.isHidden = false
                txtFieldTo.text = "\(String(format: "%.3f", coordinateTo.latitude)) - \(String(format: "%.3f", coordinateTo.longitude))"
            }
            let annotation = MKPointAnnotation()
            annotation.coordinate = coordinate
            mapView.addAnnotation(annotation)
            annotationCounter += 1
        }
    }
    
    func controlPlaceID(){
        if fromPlaceID != nil, toPlaceID != nil{
            getDirections(from: fromPlaceID!, to: toPlaceID!)
        }
    }
    
    func getDirections(from: String, to: String) {
        let origin = "place_id:\(from)"
        let destination = "place_id:\(to)"
        howIGoViewModel.getDirections(apiKey: apiKey, origin: origin, destination: destination)
    }
    
    func pushScreen(){
        let routeVC = RouteViewController()
        routeVC.routes = routeMaps?.routes
        navigationController?.pushViewController(routeVC, animated: true)
    }
    
    // MARK: -TextFields Did Change Functions
    @objc func textFieldFromDidChange(){
        filteredStations = []
        if txtFieldFrom.text == ""{
            filteredStations = stations!
        } else{
            for station in stations!{
                if station.name!.lowercased().contains(txtFieldFrom.text!.lowercased()){
                    filteredStations.append(station)
                }
            }
        }
        self.tableViewFrom.reloadData()
    }
    
    @objc func textFieldToDidChange(){
        filteredStations = []
        if txtFieldTo.text == ""{
            filteredStations = stations!
        } else{
            for station in stations!{
                if station.name!.lowercased().contains(txtFieldTo.text!.lowercased()){
                    filteredStations.append(station)
                }
            }
        }
        self.tableViewTo.reloadData()
    }
    
    // MARK: -CloseKeyboard Function
    @objc func closeKeyboard(){
        txtFieldStopTable()
    }
    
    // MARK: -Open TableViews
    @objc func txtFieldStartTableFrom() {
        if btnClear.isHidden == false{
            btnClear.isHidden = true
            rememberClear = 1
        }
        if btnDirection.isHidden == false{
            btnDirection.isHidden = true
            rememberDirection = 1
        }
        UIView.animate(withDuration: 0.3) {
            self.tableViewFrom.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    @objc func txtFieldStartTableTo() {
        if btnClear.isHidden == false{
            btnClear.isHidden = true
            rememberClear = 1
        }
        if btnDirection.isHidden == false{
            btnDirection.isHidden = true
            rememberDirection = 1
        }
        UIView.animate(withDuration: 0.3) {
            self.tableViewTo.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // MARK: -Close TableView and Keyboard
    @objc func txtFieldStopTable() {
        if rememberClear == 1{
            rememberClear = 0
            btnClear.isHidden = false
        }
        if rememberDirection == 1{
            rememberDirection = 0
            btnDirection.isHidden = false
        }
        txtFieldFrom.endEditing(true)
        txtFieldTo.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.tableViewFrom.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
            self.tableViewTo.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
        }
    }
    
    // MARK: -TableView Config
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == tableViewFrom{
            return filteredStations.count
        } else{
            return filteredStations.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        loadingScreen.stopIndicator(view: view)
        if tableView == tableViewFrom{
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
            cell.textLabel?.text = String(indexPath.row + 1) + "- " + (filteredStations[indexPath.row].name!)
            cell.textLabel?.isAccessibilityElement = true
            cell.textLabel?.accessibilityHint = filteredStations[indexPath.row].name!
        return cell
            } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
                cell.textLabel?.text = String(indexPath.row + 1) + "- " + (filteredStations[indexPath.row].name!)
                cell.textLabel?.isAccessibilityElement = true
                cell.textLabel?.accessibilityHint = filteredStations[indexPath.row].name!
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        btnClear.isHidden = false
        // MARK: Set TextField Text
        if tableView == tableViewFrom{
            txtFieldFrom.text = filteredStations[indexPath.row].name!
        } else if tableView == tableViewTo{
            txtFieldTo.text = filteredStations[indexPath.row].name!
        }
        // MARK: Remove All Annotations
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        self.mapView.removeOverlays(self.mapView.overlays)
        
        let location = CLLocation(latitude: (stations?[indexPath.row].latitude)!, longitude: (stations?[indexPath.row].longitude)!)
        if tableView == tableViewFrom{
            fromLocation = location
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: fromLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            // MARK: From Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = fromLocation.coordinate
            annotation.title = "From"
            mapView.addAnnotation(annotation)
            // MARK: To Annotation
            let annotationTo = MKPointAnnotation()
            annotationTo.coordinate = toLocation.coordinate
            annotationTo.title = "To"
            mapView.addAnnotation(annotationTo)
            txtFieldStopTable()
            coordinateFrom.latitude = (filteredStations[indexPath.row].latitude)!
            coordinateFrom.longitude = (filteredStations[indexPath.row].longitude)!
            annotationCounter += 1
        } else if tableView == tableViewTo{
            toLocation = location
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: toLocation.coordinate, span: span)
            mapView.setRegion(region, animated: true)
            // MARK: To Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = toLocation.coordinate
            annotation.title = "To"
            mapView.addAnnotation(annotation)
            // MARK: From Location
            let annotationFrom = MKPointAnnotation()
            annotationFrom.coordinate = fromLocation.coordinate
            annotationFrom.title = "From"
            mapView.addAnnotation(annotationFrom)
            txtFieldStopTable()
            coordinateTo.latitude = (filteredStations[indexPath.row].latitude)!
            coordinateTo.longitude = (filteredStations[indexPath.row].longitude)!
            annotationCounter += 1
        }
        if annotationCounter == 2{
            btnDirection.isHidden = false
        }
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
    
    func btnClearConstraints(_ view: UIView, mapView: MKMapView){
        view.addSubview(self)
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        topAnchor.constraint(equalTo: mapView.topAnchor, constant: 15).isActive = true
    }
    
    func btnDirectionConstraints(_ view: UIView, mapView: MKMapView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: mapView.topAnchor, constant: 15).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
    
    func stationsViewConstraints(_ view: UIView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        heightAnchor.constraint(equalToConstant: 120).isActive = true
    }
    
    func txtFieldFromConstraints(_ view: UIView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
        
    func txtFieldToConstraints(_ view: UIView, txtFieldFrom: UITextField){
        view.addSubview(self)
        topAnchor.constraint(equalTo: txtFieldFrom.bottomAnchor, constant: 10).isActive = true
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.85).isActive = true
        heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
        
    func tableViewConstraints(_ view: UIStackView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
        
    func stackViewConstraints(_ view: UIView, stationsView: UIView){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: stationsView.bottomAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func setMapConstraints(_ view: UIStackView){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
}
