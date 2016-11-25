//
//  Parqueaderos.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 24/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation

class Parqueaderos{
    var Parqueaderos: [Parqueadero] = [Parqueadero]()
    
    init() {
        loadParq()
    }
    
    func loadParq(){
    let client:HttpClient = HttpClient()
    client.get(url: "http://192.168.128.105:8080/parqueaderos/calif", callback: processData)
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
                    Parqueaderos.append(p)
                    
                }
                //let nombres:NSDictionary = usuario.object(forKey: "nombres") as! NSDictionary
                //let usr:NSDictionary = usuario.object(forKey: "user") as! NSDictionary
            }
        }catch{}
    }
}
