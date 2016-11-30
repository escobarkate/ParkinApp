//
//  UsuarioDAO.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 18/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation
import SQLite

class ParqueaderoDAO{
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    var db:Connection!
    
    var parqueadero:Table = Table("parqueadero")
    var id:Expression<Int> = Expression<Int>("id")
    var nombre:Expression<String> =  Expression<String>("nombre")
    var direccion:Expression<String> =  Expression<String>("direccion")
    var precio:Expression<String> =  Expression<String>("precio")
    var puestos:Expression<Int64> =  Expression<Int64>("puestos")
    var imagen:Expression<String> =  Expression<String>("imagen")
    
    
    init(){
        do{
            try db = Connection("\(path)/parqueadero.db")
            let createTable = parqueadero.create(block: {(t:TableBuilder) in
                t.column(id, primaryKey:true)
                t.column(nombre)
                t.column(direccion)
                t.column(precio)
                t.column(puestos)
                t.column(imagen)
            })
            
            try db.run(createTable)
        }catch{
        }
    }
    
    func insert(p:Parqueadero){
        let query = parqueadero.insert(id <- p.id, nombre <- p.nombre!, direccion <- p.direccion!, precio <- p.precio!, puestos <- Int64(p.lugareslibres), imagen <- p.imagen!)
        do{
            try db.run(query)
        }catch{
        }
        
    }
    
    func delete(id:Int){
        let d = parqueadero.filter(self.id == id)
        let query = d.delete()
        do{
            try db.run(query)
        }catch{
        }
    }
    func deleteAll(){
        let query = parqueadero.delete()
        do{
            try db.run(query)
        }catch{
        }
        
    }
    
    func parqById(id:Int) -> Parqueadero?{
        
        let filter = parqueadero.filter(self.id == id)
        var p:Parqueadero? = nil
        
        do{
            for row in try db.prepare(filter){

                p!.id = row[self.id]
                p!.nombre = row[nombre]
                p!.direccion = row[direccion]
                p!.precio = row[precio]
                p!.lugareslibres = Int(row[puestos])
                p!.imagen = row[imagen]
                break
            }
            
            return p
        }catch{
            return nil
        }
        
        
    }
    

}
