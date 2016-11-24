//
//  Parqueadero.swift
//  parkinApp
//
//  Created by cdt creatic on 23/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation
import UIKit

struct Parqueadero {
    var id: Int
    var nombre : String?
    var direccion: String?
    var precio :Int
    var longitud : String?
    var latitud: String?
    var calificacion : Double
    var cantidad: Int
    var imagen : String?
    var lugareslibres : Int
    var horarioApertura : String?
    var HorarioCerrado : String?
   
    
    
    init(id: Int, nombre: String?, direccion: String? , precio: Int, longitud: String?, latitud: String?, calificacion: Double, cantidad: Int, imagen: String?, lugareslibres: Int , horarioApertura: String? , horarioCerrado: String?){
        self.id = id
        self.nombre = nombre
        self.direccion = direccion
        self.precio = precio
        self.longitud = longitud
        self.latitud = latitud
        self.calificacion = calificacion
        self.cantidad = cantidad
        self.imagen = imagen
        self.lugareslibres = lugareslibres
        self.horarioApertura = horarioApertura
        self.HorarioCerrado = horarioCerrado
        
    }
}
