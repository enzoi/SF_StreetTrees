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

    override func loadView() {
        
        let camera = GMSCameraPosition.camera(withLatitude: 37.7749, longitude: -122.4194, zoom: 12.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        // Creates a marker in the center of the map.
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        marker.title = "San Francisco"
        marker.snippet = "USA"
        marker.map = mapView
        
    }
}

