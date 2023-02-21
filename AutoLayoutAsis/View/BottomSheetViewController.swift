//
//  BottomSheetViewController.swift
//  AutoLayoutAsis
//
//  Created by Harun Demirkaya on 20.02.2023.
//
// MARK: -Import Libaries
import UIKit

// MARK: -BottomSheet View Controller Class
class BottomSheetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    // MARK: -Define
    
    // MARK: Route Defined
    var route: [Step]? {
        didSet{
            getStep()
        }
    }
    
    var path: [Path] = []
    
    var pathIcon: UIImage?
    var pathDescription: UILabel?
    
    // MARK: TableView Defined
    private lazy var tableView : UITableView = {
        let table = UITableView()
        table.delegate = self
        table.dataSource = self
        table.allowsSelection = false
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]

        let screenSize = UIScreen.main.bounds.size
        let sheetHeight: CGFloat = 300
        view.frame = CGRect(x: 0, y: screenSize.height - sheetHeight, width: screenSize.width, height: sheetHeight)
        
        // MARK: TableView
        view.addSubview(tableView)
        tableView.register(RouteMapTableViewCell.self, forCellReuseIdentifier: "RouteMapTableViewCell")
    }
    
    // MARK: -TableView Frame
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
    }
    
    // MARK: -TableView for Rows
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return path.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RouteMapTableViewCell", for: indexPath) as! RouteMapTableViewCell
        let htmlText = UILabel()
        htmlText.attributedText = path[indexPath.row].meter?.text?.htmlToAttributedString
        cell.text.text = htmlText.text
        cell.iconImageView.image = path[indexPath.row].icon?.image
        return cell
    }
    
    func getStep(){
        for i in 0...route!.count-1{
            if route![i].travelMode == "WALKING"{
                pathIcon = UIImage(systemName: "figure.walk")
            } else{
                pathIcon = UIImage(systemName: "bus.fill")
            }
            pathDescription = UILabel()
            pathDescription?.text = route![i].html_instructions
            path.append(Path(icon: UIImageView(image: pathIcon), meter: pathDescription))
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let text = path[indexPath.row].meter?.text
        let font = UIFont.systemFont(ofSize: 17)
        let maxSize = CGSize(width: tableView.frame.width - 32, height: CGFloat.greatestFiniteMagnitude)
        let textHeight = NSString(string: text!).boundingRect(with: maxSize, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [.font: font], context: nil).height
        return textHeight + 32
    }
}

// MARK: -Display HTML Functions
extension String {
    var htmlToAttributedString: NSAttributedString? {
        guard let data = data(using: .utf8) else { return nil }
        do {
            return try NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html, .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil)
        } catch {
            return nil
        }
    }
    var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
}
