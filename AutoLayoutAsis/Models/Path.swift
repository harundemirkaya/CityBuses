//
//  Path.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 15.02.2023.
//

import Foundation
import UIKit

class Path{
    var icon: UIImageView?
    var meter: UILabel?
    
    init(icon: UIImageView? = nil, meter: UILabel? = nil) {
        self.icon = icon
        self.meter = meter
    }
}
