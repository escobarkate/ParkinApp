//
//  ViewControllerMapa.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 16/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation
import UIKit
import GoogleMaps

class ViewControllerMapa: UIViewController {
    
    var ParqueaderosData: [Parqueadero] = [Parqueadero]()
    override func viewDidLoad() {
        super.viewDidLoad()
        loadParqueaderos()
        self.tabBarController?.navigationItem.title = "Ubicación"
        cargarMapa()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cargarMapa(){
        let camera = GMSCameraPosition.camera(withLatitude: 2.4412,longitude: -76.6079, zoom: 16)
        
        let mapView = GMSMapView.map(withFrame: self.view.bounds  ,camera: camera)
        //mapView.isMyLocationEnabled = true
        //self.view = mapView
        
        mapView.settings.myLocationButton = true
        mapView.settings.scrollGestures=true
        mapView.settings.zoomGestures=false
        
        //marker.icon = UIImage(named: "house")
        //marker.icon = GMSMarker.markerImage(with: UIColor.blue)
        
        for p in ParqueaderosData{
            let marker1 = GMSMarker()
            let long = Double(p.longitud!)
            let lat = Double(p.latitud!)
            marker1.position = CLLocationCoordinate2DMake(lat!, long!)
            marker1.title = "Parqueadero "+p.nombre!
            marker1.snippet = p.direccion
            //marker1.icon = GMSMarker.markerImage(with: UIColor.magenta)
            marker1.map = mapView
        }
        
        view=mapView

    }
    
    func loadParqueaderos(){
        let client:HttpClient = HttpClient()
        client.get(url: "http://192.168.128.30:8080/parqueaderos/calif", callback: processData)
    }
    
    
    func processData(data:Data?){
        
        do{
            let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            
            let success:Bool = json.value(forKey: "success") as! Bool
            if success == true {
                let parq:NSArray = json.value(forKey: "parq") as! NSArray
                for i in 0 ..< parq.count{
                    let parq_obj = parq[i] as! NSDictionary
                    let id = parq_obj["id"] as! Int
                    let nombre = parq_obj["nombre"] as! String
                    let direccion = parq_obj["direccion"] as! String
                    let precio = parq_obj["precio"] as! String
                    let longitud = parq_obj["longitud"] as! String
                    let latitud = parq_obj["latitud"] as! String
                    let calificacion = parq_obj["calificacion"] as! Double
                    let cantidad = parq_obj["cantidad"] as! Int
                    let imagen = parq_obj["imagen"] as! String
                    let lugareslibres = parq_obj["lugaresLibres"] as! Int
                    let horarioApertura = parq_obj["horarioApertura"] as! String
                    let horarioCerrado = parq_obj["horarioCerrado"] as! String
                    
                    let p = Parqueadero(id: id, nombre: nombre, direccion: direccion, precio: precio, longitud: longitud, latitud: latitud, calificacion: calificacion, cantidad: cantidad, imagen: imagen, lugareslibres: lugareslibres, horarioApertura: horarioApertura, horarioCerrado: horarioCerrado)
                    ParqueaderosData.append(p)
                }
            }
        }catch{}
    }

    
    
}
