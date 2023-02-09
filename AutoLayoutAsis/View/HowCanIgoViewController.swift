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
    
    // MARK: Table Defined
    private lazy var tableView : UITableView = {
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
            tableView.reloadData()
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
    
    // MARK: StationsViewModel
    var howCanIgoViewModel = HowCanIgoViewModel()
    
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
        
        tableView.tableViewConstraints(stackView)
        tableView.transform = CGAffineTransform(translationX: 0, y: view.frame.height)
        txtFieldFrom.addTarget(self, action: #selector(txtFieldStartTable), for: .editingDidBegin)
        txtFieldTo.addTarget(self, action: #selector(txtFieldStartTable), for: .editingDidBegin)
        
        howCanIgoViewModel.howCanIgoVC = self
        howCanIgoViewModel.getStations()
        filteredStations = stationsName
        
        txtFieldFrom.inputAccessoryView = btnCloseKeyboard
        txtFieldTo.inputAccessoryView = btnCloseKeyboard
        btnCloseKeyboard.addTarget(self, action: #selector(closeKeyboard), for: .touchUpInside)
        
    }
    
    // MARK: -CloseKeyboard Function
    @objc func closeKeyboard(){
        txtFieldStopTable()
    }
    
    // MARK: -Open Table
    @objc func txtFieldStartTable() {
        UIView.animate(withDuration: 0.3) {
            self.tableView.transform = CGAffineTransform(translationX: 0, y: 0)
        }
    }
    
    @objc func txtFieldStopTable() {
        txtFieldFrom.endEditing(true)
        txtFieldTo.endEditing(true)
        UIView.animate(withDuration: 0.3) {
            self.tableView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.height)
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
        let location = CLLocationCoordinate2D(latitude: (stations?[indexPath.row].latitude)!, longitude: (stations?[indexPath.row].longitude)!)
        let span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
        let region = MKCoordinateRegion(center: location, span: span)
        mapView.setRegion(region, animated: true)
        let annotation = MKPointAnnotation()
        annotation.coordinate = location
        mapView.addAnnotation(annotation)
        txtFieldStopTable()
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
}
