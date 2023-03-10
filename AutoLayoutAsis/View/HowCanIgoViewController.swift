//
//  HowCanIgoViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 9.02.2023.
//
// MARK: -Import Libaries
import UIKit
import MapKit
import CoreLocation

// MARK: -HowCanIgoViewController Class
class HowCanIgoViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, UITableViewDelegate, UITableViewDataSource{

    // MARK: -Define
    
    // MARK: Map Defined
    let mapView: MKMapView = {
        let map = MKMapView()
        map.overrideUserInterfaceStyle = .dark
        return map
    }()
    
    // MARK: Location Manager Defined
    var locationManager = CLLocationManager()
    
    // MARK: stationsView Defined
    var stationsView: UIView = {
        var view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    // MARK: StationsViewModel
    var howCanIgoViewModel = HowCanIgoViewModel()
    
    var btnDirections: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .purple
        btn.setTitle("directions".localized(), for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.layer.cornerRadius = 15
        return btn
    }()
    
    var services: [Service]?
    
    var stopServices: StopServices? {
        didSet{
            if stopServices != nil{
                filterService()
            }
        }
    }
    
    var pathCounter = 0
    
    var path: [Path] = []
    
    var selectedFromStopID = 0
    
    var nearestStation: [CLLocation] = []
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: Set Station View Constraints
        
        stationsView.stationsViewConstraints(view)
        txtFieldFrom.txtFieldFromConstraints(stationsView)
        txtFieldTo.txtFieldToConstraints(stationsView, txtFieldFrom: txtFieldFrom)
        stackView.stackViewConstraints(view, stationsView: stationsView)
        
        // MARK: Set Constraints
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
        
        tableViewFrom.tableViewConstraints(stackView)
        tableViewTo.tableViewConstraints(stackView)
        tableViewFrom.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        tableViewTo.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        txtFieldFrom.addTarget(self, action: #selector(txtFieldStartTableFrom), for: .editingDidBegin)
        txtFieldTo.addTarget(self, action: #selector(txtFieldStartTableTo), for: .editingDidBegin)
        
        howCanIgoViewModel.howCanIgoVC = self
        howCanIgoViewModel.getServices()
        howCanIgoViewModel.getStations()
        filteredStations = stationsName
        
        txtFieldFrom.inputAccessoryView = btnCloseKeyboard
        txtFieldTo.inputAccessoryView = btnCloseKeyboard
        btnCloseKeyboard.addTarget(self, action: #selector(closeKeyboard), for: .touchUpInside)
        
        // MARK: Search Algorithm
        txtFieldFrom.addTarget(self, action: #selector(textFieldFromDidChange), for: .editingChanged)
        txtFieldTo.addTarget(self, action: #selector(textFieldToDidChange), for: .editingChanged)
        
        btnDirections.btnDirectionsConstraints(stackView)
        btnDirections.addTarget(self, action: #selector(btnDirectionsTarget), for: .touchUpInside)
        btnDirections.isHidden = true
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
    
    // MARK: -Get User Location and Set Annotation
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
      guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else { return }
      let region = MKCoordinateRegion(center: locValue, latitudinalMeters: 1000, longitudinalMeters: 1000)
      mapView.setRegion(region, animated: true)
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // MARK: Set TextField Text
        if tableView == tableViewFrom{
            txtFieldFrom.text = filteredStations[indexPath.row]
        } else if tableView == tableViewTo{
            txtFieldTo.text = filteredStations[indexPath.row]
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
            selectedFromStopID = (stations?[indexPath.row].stopID)!
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
        }
        if fromLocation.coordinate.latitude != 0, toLocation.coordinate.latitude != 0{
            btnDirections.isHidden = false
        }
    }
    
    // MARK: -Btn Directions Clicked
    @objc func btnDirectionsTarget(){
        howCanIgoViewModel.selectedStopID = selectedFromStopID
        howCanIgoViewModel.getStopServices()
    }
    
    // MARK: -Set Annotations Image
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: "custom")
        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "custom")
        } else{
            annotationView?.annotation = annotation
        }
        if annotation.title == "From"{
            annotationView?.image = UIImage(named: "start-point-tr")
        } else if annotation.title == "To"{
            annotationView?.image = UIImage(named: "stop-point-tr")
        }
        return annotationView
    }

    // MARK: -Filtered Services
    func filterService(){
        if pathCounter < 5{
            let result = filterConfig(stopServices: stopServices)
            let distance = result.keys.first
            var loopCounter = 0
            if !path.isEmpty{
                for i in 0...path.count-1{
                    if distance!! <= path[i].distance!{
                        loopCounter += 1
                    }
                }
            }
            if loopCounter == path.count{
                
                path.append(Path(distance: distance!!, location: result[distance!!]))
            }
            if distance!! > 750{
                howCanIgoViewModel.selectedStopID = selectedFromStopID
                howCanIgoViewModel.getStopServices()
            } else{
                drawPolyline()
            }
            path = removeDuplicatePaths(path)
            pathCounter += 1
        }
    }
    
    func removeDuplicatePaths(_ paths: [Path]) -> [Path] {
        var uniquePaths = [Path]()
        for path in paths {
            if !uniquePaths.contains(where: { $0.location == path.location && $0.distance == path.distance }) {
                uniquePaths.append(path)
            }
        }
        return uniquePaths
    }
    
    func filterConfig(stopServices: StopServices?) -> [Double? : CLLocation]{
        var stopServicesArr: [String]?
        var stopID: [Int] = []
        var result: [Double? : CLLocation] = [0.0 : CLLocation()]
        if stopServices != nil, services != nil{
            var distance: [Double] = []
            stopServicesArr = stopServices?.departures.reduce([], { $0.contains($1.serviceName) ? $0 : $0 + [$1.serviceName] })
            for i in 0...stopServicesArr!.count-1{
                for j in 0...services!.count-1{
                    if stopServicesArr![i] == services![j].name{
                        for k in 0...services![j].routes![0].points!.count-1{
                            if services![j].routes![0].points![k].stopID != nil{
                                let pointLocation = CLLocation(latitude: Double(services![j].routes![0].points![k].latitude!)!, longitude: Double(services![j].routes![0].points![k].longitude!)!)
                                distance.append(pointLocation.distance(from: toLocation))
                                nearestStation.append(pointLocation)
                                stopID.append(Int(services![j].routes![0].points![k].stopID ?? "") ?? 0)
                            }
                        }
                    }
                }
            }
            let minIndex = distance.firstIndex(of: distance.min()!)
            result = [distance.min() : nearestStation[minIndex!]]
            selectedFromStopID = stopID[minIndex!]
        }
        return result
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
    
    var routeOverlay: MKOverlay?
    func drawPolyline(){
        var coordinates: [CLLocationCoordinate2D] = []
        for pat in path {
            guard let location = pat.location else { continue }
            coordinates.append(CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude))
        }
        
        DispatchQueue.main.async {
            self.routeOverlay = MKPolyline(coordinates: coordinates, count: coordinates.count)
            self.mapView.addOverlay(self.routeOverlay!, level: .aboveRoads)
            let customEdgePadding: UIEdgeInsets = UIEdgeInsets(top: 50, left: 50, bottom: 50, right: 50)
            self.mapView.setVisibleMapRect(self.routeOverlay!.boundingMapRect, edgePadding: customEdgePadding ,animated: true)
        }
    }
}

public extension UIView{
    func setMapConstraints(_ view: UIStackView){
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
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
    
    func btnDirectionsConstraints(_ view: UIView){
        view.addSubview(self)
        bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -15).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15).isActive = true
    }
}
