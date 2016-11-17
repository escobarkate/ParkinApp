//
//  ViewControllerReg.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 16/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation

import UIKit
import GoogleMaps

class ViewControllerReg: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        let camera = GMSCameraPosition.camera(withLatitude: 2.4412,longitude: -76.6079, zoom: 16)
        
        let mapView = GMSMapView.map(withFrame: self.view.bounds  ,camera: camera)
        //mapView.isMyLocationEnabled = true
        //self.view = mapView
        
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures=true
        mapView.settings.zoomGestures=false
        
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2DMake(2.442716, -76.605459)
        marker.title = "Parqueadero Artes"
        marker.snippet = "Dirección: Cra 20 c 7a 123"
        
        
        //marker.icon = UIImage(named: "house")
        //marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        marker.appearAnimation = kGMSMarkerAnimationPop
        marker.isFlat = true
        marker.map = mapView
        
        let marker1 = GMSMarker()
        marker1.position = CLLocationCoordinate2DMake(2.441680, -76.607344)
        marker1.title = "Parqueadero Patiño"
        marker1.snippet = "Dirección: Cra 20 c 7a 125"
        marker1.icon = GMSMarker.markerImage(with: UIColor.cyan)
        marker1.map = mapView
        
        let marker2 = GMSMarker()
        marker2.position = CLLocationCoordinate2DMake(2.440713, -76.607331)
        marker2.title = "Parqueadero Hotel Achalay"
        marker2.icon = GMSMarker.markerImage(with: UIColor.magenta)
        marker2.snippet = "Dirección: Calle 6 #7-18"
        marker2.map = mapView
        
        view=mapView
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

