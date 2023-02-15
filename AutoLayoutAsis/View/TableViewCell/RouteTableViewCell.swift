//
//  RouteTableViewCell.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 15.02.2023.
//

import UIKit

class RouteTableViewCell: UITableViewCell {
    
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
    
    let lblTotalDistance = UILabel()
    
    let divider: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .gray
        view.backgroundColor = .gray
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        lblTotalDistance.translatesAutoresizingMaskIntoConstraints = false
        lblTotalDistance.font = lblTotalDistance.font.withSize(12)
        addSubview(lblTotalDistance)
        lblTotalDistance.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        lblTotalDistance.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        
        addSubview(divider)
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.bottomAnchor.constraint(equalTo: lblTotalDistance.topAnchor, constant: -5).isActive = true
        divider.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
        divider.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true
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
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: bottomAnchor),
        ])

        let stackView = UIStackView()
        scrollView.addSubview(stackView)
        stackView.axis = .horizontal
        stackView.alignment = .leading
        stackView.distribution = .equalSpacing
            
        for (index, pathIndex) in path.enumerated() {
            let iconView = UIView()
            iconView.backgroundColor = .clear
            let iconImageView = pathIndex.icon
            iconView.addSubview(iconImageView!)
                
            let meterLabel = UILabel()
            meterLabel.text = pathIndex.meter?.text
            meterLabel.font = meterLabel.font.withSize(12)
            
            let verticalStackView = UIStackView(arrangedSubviews: [iconView, meterLabel])
            verticalStackView.axis = .vertical
            verticalStackView.alignment = .center
            verticalStackView.distribution = .fill
            verticalStackView.spacing = 20
                
            stackView.addArrangedSubview(verticalStackView)
                
            if index < path.count - 1 {
                let separatorLabel = UILabel()
                separatorLabel.text = ">"
                stackView.addArrangedSubview(separatorLabel)
            }
        }
        
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
