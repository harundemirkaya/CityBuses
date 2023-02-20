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
    
    var networkManager = NetworkManager()
    
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
        btn.setTitle("   Clear   ", for: UIControl.State.normal)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    var btnDirection: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .purple
        btn.setTitle("   Direction   ", for: UIControl.State.normal)
        btn.layer.cornerRadius = 10
        return btn
    }()
    
    // MARK: TextField Defined
    var txtFieldFrom: UITextField = {
        let txtField = UITextField()
        txtField.translatesAutoresizingMaskIntoConstraints = false
        txtField.placeholder = "from".localized()
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
                for i in 0...stations!.count-1{
                    stationsName.append(stations![i].name!)
                }
            }
            filteredStations = stationsName
            tableViewFrom.reloadData()
            tableViewTo.reloadData()
        }
    }
    var stationsName: [String] = []
    var filteredStations: [String] = []
    
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
        btn.setTitle("Close Keyboard", for: UIControl.State.normal)
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
        
        btnClear.btnClearConstraints(view)
        btnClear.addTarget(self, action: #selector(btnClearTarget), for: .touchUpInside)
        
        btnDirection.btnDirectionConstraints(view)
        btnDirection.addTarget(self, action: #selector(btnDirectionTarget), for: .touchUpInside)
        btnDirection.isHidden = true
        btnClear.isHidden = true
    }
    
    @objc func btnClearTarget(){
        btnDirection.isHidden = true
        let allAnnotations = self.mapView.annotations
        self.mapView.removeAnnotations(allAnnotations)
        annotationCounter = 0
        btnClear.isHidden = true
    }
    
    @objc func btnDirectionTarget(){
        convertCoordinatesToPlaceID(latitude: coordinateFrom.latitude, longitude: coordinateFrom.longitude) { (placeID) in
            if let placeID = placeID {
                self.fromPlaceID = placeID
            }
        }
        convertCoordinatesToPlaceID(latitude: coordinateTo.latitude, longitude: coordinateTo.longitude) { (placeID) in
            if let placeID = placeID {
                self.toPlaceID = placeID
            }
        }
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
            } else if annotationCounter == 1{
                coordinateTo.latitude = coordinate.latitude
                coordinateTo.longitude = coordinate.longitude
                btnDirection.isHidden = false
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
        let routeVC = RouteViewController()
        routeVC.routes = routeMaps?.routes
        navigationController?.pushViewController(routeVC, animated: true)
    }
    
    // MARK: -TextFields Did Change Functions
    @objc func textFieldFromDidChange(){
        filteredStations = []
        if txtFieldFrom.text == ""{
            filteredStations = stationsName
        } else{
            for station in stationsName{
                if station.lowercased().contains(txtFieldFrom.text!.lowercased()){
                    filteredStations.append(station)
                }
            }
        }
        self.tableViewFrom.reloadData()
    }
    
    @objc func textFieldToDidChange(){
        filteredStations = []
        if txtFieldTo.text == ""{
            filteredStations = stationsName
        } else{
            for station in stationsName{
                if station.lowercased().contains(txtFieldTo.text!.lowercased()){
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
        UIView.animate(withDuration: 0.3) {
            self.tableViewFrom.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    @objc func txtFieldStartTableTo() {
        UIView.animate(withDuration: 0.3) {
            self.tableViewTo.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    // MARK: -Close TableView and Keyboard
    @objc func txtFieldStopTable() {
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
        if tableView == tableViewFrom{
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
            cell.textLabel?.text = String(indexPath.row + 1) + "- " + (filteredStations[indexPath.row])
        return cell
            } else{
            let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
            cell.textLabel?.text = String(indexPath.row + 1) + "- " + (filteredStations[indexPath.row])
            return cell
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

public extension UIView{
    func mapConstraints(_ view: UIView){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
    }
    
    func btnClearConstraints(_ view: UIView){
        view.addSubview(self)
        leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15).isActive = true
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
    }
    
    func btnDirectionConstraints(_ view: UIView){
        view.addSubview(self)
        topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 15).isActive = true
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
