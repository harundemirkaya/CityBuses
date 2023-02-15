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
}
