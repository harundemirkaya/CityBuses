//
//  RouteMapTableViewCell.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 20.02.2023.
//

import UIKit

class RouteMapTableViewCell: UITableViewCell {

    var iconImageView: UIImageView = {
           let imageView = UIImageView()
           imageView.contentMode = .scaleAspectFit
           return imageView
       }()
       
       let text: UILabel = {
           let label = UILabel()
           label.numberOfLines = 0
           label.font = UIFont.systemFont(ofSize: 16)
           return label
       }()
       
       override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
           super.init(style: style, reuseIdentifier: reuseIdentifier)
           
           contentView.addSubview(iconImageView)
           contentView.addSubview(text)
       }
       
       required init?(coder: NSCoder) {
           fatalError("init(coder:) has not been implemented")
       }
       
       override func layoutSubviews() {
           super.layoutSubviews()
           
           // iconImageView'ın çerçevesini ayarla
           let iconSize: CGFloat = contentView.frame.height * 0.6
           let iconFrame = CGRect(x: 16, y: (contentView.frame.height - iconSize) / 2, width: iconSize, height: iconSize)
           iconImageView.frame = iconFrame
           
           // textLabel'ın çerçevesini ayarla
           let textX = iconFrame.maxX + 16
           let textFrame = CGRect(x: textX, y: 0, width: contentView.frame.width - textX - 16, height: contentView.frame.height)
           text.frame = textFrame
       }
}
