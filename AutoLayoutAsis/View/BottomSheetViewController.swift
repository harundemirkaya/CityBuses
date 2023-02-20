//
//  BottomSheetViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 20.02.2023.
//

import UIKit

class BottomSheetViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
            
        // Taban sayfasının görünümünü burada yapılandırın
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        
        // Taban sayfasının boyutunu ayarlayın
        let screenSize = UIScreen.main.bounds.size
        let sheetHeight: CGFloat = 300
        view.frame = CGRect(x: 0, y: screenSize.height - sheetHeight, width: screenSize.width, height: sheetHeight)
    }
}
