//
//  RouteViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 15.02.2023.
//
// MARK: -Import Libaries
import UIKit

// MARK: -RouteViewController Class
class RouteViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: -Define
    
    // MARK: TableView Defined
    private lazy var tableView : UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        return table
    }()
    
    var routes: [RouteMap]?
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()

        // MARK: Screen
        view.backgroundColor = .white
        
        // MARK: TableView
        view.addSubview(tableView)
        tableView.register(RouteTableViewCell.self, forCellReuseIdentifier: "RouteTableViewCell")
    }
    
    // MARK: -TableView Frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: -TableView for Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if routes != nil{
            return routes!.count
        } else{
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteTableViewCell", for: indexPath) as! RouteTableViewCell
        let route = routes![indexPath.row].legs[0]
        cell.nameLabel.text = "Yol"
        cell.distanceLabel.text = "Mesafe: \(route.distance.text)"
        cell.durationLabel.text = "Süre: \(route.duration.text)"
        return cell
    }
}
