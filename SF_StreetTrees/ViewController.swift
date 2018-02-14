//
//  ViewController.swift
//  SF_StreetTrees
//
//  Created by Yeontae Kim on 2/12/18.
//  Copyright © 2018 YTK. All rights reserved.
//

import UIKit
import GoogleMaps

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Street Trees"
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 15.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        mapView.delegate = self
        
        var data = readDataFromCSV(fileName: "tree_export_nHwpYpp", fileType: "csv")
        data = cleanRows(file: data!)
        let csvRows = csv(data: data!)
        
        var index = 0
        
        for row in csvRows.dropFirst() {
            let rowArray = row[0].components(separatedBy: ",")
            
            var name: String
            
            print(rowArray)
            
            if rowArray.count < 17 {
                return
            } else {
                if rowArray[17] != "" {
                    name = rowArray[17] // common name
                } else {
                    name = ""
                }
            }
            
            guard let lat = Double(rowArray[1]) else { return }
            guard let lon = Double(rowArray[0]) else { return }
            
            let marker = GMSMarker()
            marker.title = name
            marker.position = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            
            let markerView = UIImageView(frame: CGRect(x: 0, y: 0, width: 5, height: 5))
            markerView.backgroundColor = .red
            markerView.layer.borderColor = UIColor.white.cgColor
            markerView.layer.borderWidth = 0.5
            markerView.layer.cornerRadius = 2.5
            markerView.layer.masksToBounds = true
            
            marker.iconView = markerView
            marker.map = mapView
            
            index += 1
            if index == 10000 {
                break
            }
        }
    }
    
    // code modified from: https://stackoverflow.com/questions/43295163/swift-3-1-how-to-get-array-or-dictionary-from-csv
    func readDataFromCSV(fileName:String, fileType: String)-> String!{
        guard let filepath = Bundle.main.path(forResource: fileName, ofType: fileType)
            else {
                return nil
        }
        do {
            var contents = try String(contentsOfFile: filepath, encoding: .utf8)
            contents = cleanRows(file: contents)
            return contents
        } catch {
            print("File Read Error for file \(filepath)")
            return nil
        }
    }
    
    func cleanRows(file:String)->String{
        var cleanFile = file
        cleanFile = cleanFile.replacingOccurrences(of: "\r", with: "\n")
        cleanFile = cleanFile.replacingOccurrences(of: "\n\n", with: "\n")
        return cleanFile
    }
    
    func csv(data: String) -> [[String]] {
        var result: [[String]] = []
        let rows = data.components(separatedBy: "\n")
        for row in rows {
            let columns = row.components(separatedBy: ";")
            result.append(columns)
        }
        return result
    }
}

extension ViewController: GMSMapViewDelegate {
    /* handles Info Window tap */
    func mapView(_ mapView: GMSMapView, didTapInfoWindowOf marker: GMSMarker) {
        print("didTapInfoWindowOf")
    }
    
    /* handles Info Window long press */
    func mapView(_ mapView: GMSMapView, didLongPressInfoWindowOf marker: GMSMarker) {
        print("didLongPressInfoWindowOf")
    }
    
    /* set a custom Info Window */
    func mapView(_ mapView: GMSMapView, markerInfoWindow marker: GMSMarker) -> UIView? {
        let view = UIView(frame: CGRect.init(x: 0, y: 0, width: 150, height: 30))
        view.backgroundColor = UIColor.white
        view.layer.cornerRadius = 6
        
        let label = UILabel()
        label.frame.size = label.intrinsicContentSize
        label.text = marker.title
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .black
        view.addSubview(label)
        label.anchor(top: view.topAnchor, left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingTop: 8, paddingLeft: 8, paddingBottom: 8, paddingRight: 8, width: 0, height: 0)
        
        return view
    }
    
}

extension UIView {
    func anchor(top: NSLayoutYAxisAnchor?, left: NSLayoutXAxisAnchor?, bottom: NSLayoutYAxisAnchor?, right: NSLayoutXAxisAnchor?,  paddingTop: CGFloat, paddingLeft: CGFloat, paddingBottom: CGFloat, paddingRight: CGFloat, width: CGFloat, height: CGFloat) {
        
        translatesAutoresizingMaskIntoConstraints = false // Use AutoLayout
        
        if let top = top {
            self.topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true
        }
        
        if let left = left {
            self.leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true
        }
        
        if let bottom = bottom {
            bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true
        }
        
        if let right = right {
            rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true
        }
        
        if width != 0 {
            widthAnchor.constraint(equalToConstant: width).isActive = true
        }
        
        if height != 0 {
            heightAnchor.constraint(equalToConstant: height).isActive = true
        }
    }
    
}

