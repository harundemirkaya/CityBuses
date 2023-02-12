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
    var fromLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0){
        didSet{
            if !stations!.isEmpty{
                for i in 0...stations!.count-1{
                    if stations![i].latitude == fromLocation.latitude, stations![i].longitude == fromLocation.longitude{
                        fromID = stations![i].stopID!
                    }
                }
            }
        }
    }
    var toLocation: CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: 0, longitude: 0){
        didSet{
            if !stations!.isEmpty{
                for i in 0...stations!.count-1{
                    if stations![i].latitude == toLocation.latitude, stations![i].longitude == toLocation.longitude{
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
    
    var stopToStop: StopToStop?{
        didSet{
            print(stopToStop)
        }
    }
    
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
        return filteredStations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = String(indexPath.row + 1) + "- " + (filteredStations[indexPath.row])
        return cell
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
        
        let location = CLLocationCoordinate2D(latitude: (stations?[indexPath.row].latitude)!, longitude: (stations?[indexPath.row].longitude)!)
        if tableView == tableViewFrom{
            fromLocation = location
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: fromLocation, span: span)
            mapView.setRegion(region, animated: true)
            // MARK: From Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = fromLocation
            annotation.title = "From"
            mapView.addAnnotation(annotation)
            // MARK: To Annotation
            let annotationTo = MKPointAnnotation()
            annotationTo.coordinate = toLocation
            annotationTo.title = "To"
            mapView.addAnnotation(annotationTo)
            txtFieldStopTable()
        } else if tableView == tableViewTo{
            toLocation = location
            let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
            let region = MKCoordinateRegion(center: toLocation, span: span)
            mapView.setRegion(region, animated: true)
            // MARK: To Annotation
            let annotation = MKPointAnnotation()
            annotation.coordinate = toLocation
            annotation.title = "To"
            mapView.addAnnotation(annotation)
            // MARK: From Location
            let annotationFrom = MKPointAnnotation()
            annotationFrom.coordinate = fromLocation
            annotationFrom.title = "From"
            mapView.addAnnotation(annotationFrom)
            txtFieldStopTable()
        }
        if fromLocation.latitude != 0, toLocation.latitude != 0{
            btnDirections.isHidden = false
        }
    }
    
    // MARK: -Btn Directions Clicked
    @objc func btnDirectionsTarget(){
        howCanIgoViewModel.getPaths(startStopID: fromID, finishStopID: toID)
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
