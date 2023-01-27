//
//  DealersViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 24.01.2023.
//

import UIKit

class DealersViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var dealers: [String] = [
        NSLocalizedString("dealer", comment: "Dealer Name"),
        NSLocalizedString("dealer", comment: "Dealer Name"),
        NSLocalizedString("dealer", comment: "Dealer Name"),
        NSLocalizedString("dealer", comment: "Dealer Name")
    ]
    
    var tableView = UITableView()
    
    var pageTitle: UILabel {
        let label = UILabel()
        label.text = NSLocalizedString("dealersPageTitle", comment: "Dealers Page Title")
        return label
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        
        navigationItem.titleView = pageTitle
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dealers.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = dealers[indexPath.row]
        return cell
    }
}
