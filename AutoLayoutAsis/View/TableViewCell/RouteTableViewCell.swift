//
//  RouteTableViewCell.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 15.02.2023.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
    let nameLabel = UILabel()
    let distanceLabel = UILabel()
    let durationLabel = UILabel()
    
    
    var icon: UIImage?
    var meter: UILabel?
    var path: [Path] = [] {
        didSet{
            if steps != nil{
                if path.count == steps!.count{
                    setSubView()
                }
            }
        }
    }
    
    var steps: [Step]? {
        didSet{
            if steps != nil{
                getStep()
            }
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.font = UIFont.boldSystemFont(ofSize: 16.0)
        contentView.addSubview(nameLabel)
        
        
        distanceLabel.translatesAutoresizingMaskIntoConstraints = false
        distanceLabel.font = UIFont.systemFont(ofSize: 14.0)
        contentView.addSubview(distanceLabel)
        
        
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.font = UIFont.systemFont(ofSize: 14.0)
        contentView.addSubview(durationLabel)
        
        
        let marginGuide = contentView.layoutMarginsGuide
        
        nameLabel.topAnchor.constraint(equalTo: marginGuide.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        nameLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        
        distanceLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0).isActive = true
        distanceLabel.leadingAnchor.constraint(equalTo: marginGuide.leadingAnchor).isActive = true
        distanceLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
        durationLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8.0).isActive = true
        durationLabel.leadingAnchor.constraint(equalTo: distanceLabel.trailingAnchor, constant: 8.0).isActive = true
        durationLabel.trailingAnchor.constraint(equalTo: marginGuide.trailingAnchor).isActive = true
        durationLabel.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func getStep(){
        for i in 0...steps!.count-1{
            if steps![i].travelMode == "WALKING"{
                icon = UIImage(systemName: "figure.walk")
            } else{
                icon = UIImage(systemName: "bus.fill")
            }
            meter = UILabel()
            meter?.text = steps![i].distance.text
            path.append(Path(icon: UIImageView(image: icon), meter: meter))
        }
    }
    
    func setSubView(){
        let scrollView = UIScrollView()
        scrollView.isDirectionalLockEnabled = true
        addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])

        let stackView = UIStackView()
        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        stackView.spacing = 6
            
        for (index, pathIndex) in path.enumerated() {
            // her bir öğe için birer view oluştur
            let iconView = UIView()
            iconView.backgroundColor = .clear
            let iconImageView = pathIndex.icon
            iconView.addSubview(iconImageView!)
                
            let meterLabel = UILabel()
            meterLabel.text = pathIndex.meter?.text
            meterLabel.font = meterLabel.font.withSize(12)
            
            // icon ve metre label'ını yatay olarak hizala
            let horizontalStackView = UIStackView(arrangedSubviews: [iconView, meterLabel])
            horizontalStackView.axis = .vertical
            horizontalStackView.alignment = .center
            horizontalStackView.distribution = .fillProportionally
            horizontalStackView.spacing = 20
                
            // stack view'a ekle
            stackView.addArrangedSubview(horizontalStackView)
                
            // son indise kadar > işareti ekle
            if index < path.count - 1 {
                let separatorLabel = UILabel()
                separatorLabel.text = ">"
                stackView.addArrangedSubview(separatorLabel)
            }
        }
        
        // horizontal stack view'ın content size'ını belirle
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
            stackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
            stackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -8),
            stackView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
            stackView.widthAnchor.constraint(greaterThanOrEqualTo: scrollView.widthAnchor)
        ])
    }
}
