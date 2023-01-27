//
//  MenuTableViewCell.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 23.01.2023.
//
// MARK: -Import Libaries
import UIKit

// MARK: -Menu Table View Cell Class
class MenuTableViewCell: UITableViewCell {
    
    // MARK: -Define Identifier
    static let identifier = "MenuTableViewCell"
    
    // MARK: -Run Init and Style
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .white
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
