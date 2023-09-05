//
//  MyMapViewController.swift
//  STYLiSH
//
//  Created by 王昱淇 on 2023/9/5.
//  Copyright © 2023 AppWorks School. All rights reserved.
//

import UIKit
import MapKit

class MyMapViewController: UIViewController {
    
    var address = ""
    
    var mapView = {
        let map = MKMapView()
        map.translatesAutoresizingMaskIntoConstraints = false
        return map
    }()

    let studioAnnotation = MKPointAnnotation()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(address)
        view.backgroundColor = .white
        setUI()
    }
    
    func setUI() {
        view.addSubview(mapView)
        
        NSLayoutConstraint.activate([
            mapView.topAnchor.constraint(equalTo: view.topAnchor),
            mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            mapView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            mapView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
}
