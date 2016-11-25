//
//  UsuarioDAO.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 18/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation

import SQLite

class UsuarioDAO{
    
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    
    var db:Connection!
    
    var usuario:Table = Table("usuario")
    var id:Expression<Int64> = Expression<Int64>("id")
    var nombre:Expression<String> =  Expression<String>("nombre")
    var user:Expression<String> =  Expression<String>("user")
    
    
    init(){
        do{
            try db = Connection("\(path)/usuario.db")
            let createTable = usuario.create(block: {(t:TableBuilder) in
                t.column(id, primaryKey:true)
                t.column(nombre)
                t.column(user)
            })
            
            try db.run(createTable)
        }catch{
        }
    }
    
    func insert(u:Usuario){
        let query = usuario.insert(id <- u.id, nombre <- u.nombre, user <- u.user)
        do{
            try db.run(query)
        }catch{
        }
        
    }
    
    func update(u:Usuario){
        let usu = usuario.filter(user == u.user)
        let query = usu.update(nombre <- u.nombre, user <- u.user)
        do{
            try db.run(query)
        }catch{
        }
    }
    
    func delete(id:Int64){
        let d = usuario.filter(self.id == id)
        let query = d.delete()
        do{
            try db.run(query)
        }catch{
        }
    }
    
    func planetaById(id:Int64) -> Usuario?{
        
        let filter = usuario.filter(self.id == id)
        var p:Usuario? = nil
        
        do{
            for row in try db.prepare(filter){
                
                p = Usuario()
                
                p!.id = row[self.id]
                p!.nombre = row[nombre]
                p!.user = row[user]
                break
            }
            
            return p
        }catch{
            return nil
        }
        
        
    }
    
    func all()->[Usuario]{
        var data:[Usuario] = []
        let sql:String = "SELECT * FROM usuario"
        
        do{
            
            for row in try db.prepare(sql){
                
                let p:Usuario = Usuario()
                p.id = row[0] as! Int64
                p.nombre = row[1] as! String
                p.user = row[2] as! String
                data.append(p)
                
            }
            
        }catch{}
        
        
        return data
        
}
}
