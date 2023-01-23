//
//  HomeViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 23.01.2023.
//

import UIKit

class HomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{

    var isSlideMenuPresented = false
    
    lazy var slideInMenuPadding: CGFloat = self.view.frame.width * 0.30
    
    lazy var menuBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "sidebar.leading")?.withRenderingMode(.alwaysOriginal), style: .done, target: self, action: #selector(menuBarButtonItemTapped))
    
    lazy var menuView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .systemGray5
        tableView.register(MenuTableViewCell.self, forCellReuseIdentifier: MenuTableViewCell.identifier)
        return view
    }()
    
    lazy var containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemBackground
        return view
    }()
    
    let tableView = UITableView()

    var menuItems = [
        "Anasayfa",
        "Otobüsüm Nerede?",
        "Duraklar",
        "Bayiler",
        "Bakiye Sorgula",
        "Ayarlar",
        "Uygulamayı Paylaş",
        "Dili Değiştir"
        ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Home Page"
        navigationItem.setLeftBarButton(menuBarButtonItem, animated: false)
        
        
        menuView.pinMenuTo(view, with: slideInMenuPadding)
        containerView.edgeTo(view)
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    @objc func menuBarButtonItemTapped(){
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0) {
            self.containerView.frame.origin.x = self.isSlideMenuPresented ? 0 : self.containerView.frame.width - self.slideInMenuPadding
        } completion: { (finished) in
            self.isSlideMenuPresented.toggle()
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 8
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: MenuTableViewCell.identifier, for: indexPath)
        cell.textLabel?.text = menuItems[indexPath.row]
        return cell
    }
}

public extension UIView {
    func edgeTo(_ view: UIView) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
    
    func pinMenuTo(_ view: UIView, with constant: CGFloat) {
        view.addSubview(self)
        translatesAutoresizingMaskIntoConstraints = false
        topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -constant).isActive = true
        bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
