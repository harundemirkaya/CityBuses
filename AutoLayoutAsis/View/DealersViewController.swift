//
//  DealersViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//
// MARK: -Import Libaries
import UIKit

// MARK: Dealers Class
class DealersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: -Define
    
    // MARK: Dealers Defined
    var dealers: [String] = [
        NSLocalizedString("dealer", comment: "Dealer Name"),
        NSLocalizedString("dealer", comment: "Dealer Name"),
        NSLocalizedString("dealer", comment: "Dealer Name"),
        NSLocalizedString("dealer", comment: "Dealer Name")
    ]
    
    // MARK: TableView Defined
    private lazy var tableView : UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        return table
    }()
    
    // MARK: Page Title Defined
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("dealersPageTitle", comment: "Dealers Page Title")
        return label
    }
    
    // MARK: -ViewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // MARK: Screen
        view.backgroundColor = .white
        navigationItem.titleView = pageTitle
        
        // MARK: TableView
        view.addSubview(tableView)
    }
    
    // MARK: -TableView Frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: -TableView for Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dealers[indexPath.row]
        return cell
    }
}
