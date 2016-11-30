//
//  FavoritosTableViewController.swift
//  parkinApp
//
//  Created by cdt creatic on 24/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class FavoritosTableViewController: UITableViewController {
    
    @IBOutlet var Favorite: UITableView!
    var ParqueaderosFav: [Parqueadero] = [Parqueadero]()
    var ParqueaderosNoFav: [Parqueadero] = [Parqueadero]()
    var idParq:[Int]=[]
    
    var dao:UsuarioDAO!
    let client:HttpClient = HttpClient()
    var user:[Usuario] = []
    
    let section = ["Favoritos", "No favoritos"]
    
    let items = [["Parqueadero 1", "Parqueadero 3", "Parqueadero 4"], ["Parqueadero 2", "Parqueadero 5"]]
    
    var userID:Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Parqueaderos favoritos"
        dao = UsuarioDAO()
        user = dao.all()
        userID = Int(user[0].id)
        loadFav(u: String(userID))
        loadParqueaderos()
        print(ParqueaderosFav)
        print(ParqueaderosNoFav)
        DispatchQueue.main.async {
            self.Favorite.reloadData()
        }
        

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //loadParqueaderos()
        Favorite.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data sourcex
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.section[section]
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return section.count
        
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0{
            return ParqueaderosFav.count
        }else{
            return ParqueaderosNoFav.count
        }
        // #warning Incomplete implementation, return the number of rows
        //return items[section].count
    }
    

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell
        if indexPath.section == 0 {
            cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
            print(ParqueaderosFav)
            //print(ParqueaderosFav[indexPath.row])
            
            let p = ParqueaderosFav[indexPath.row] as Parqueadero
            
            if let nameLabel = cell.viewWithTag(100) as? UILabel {
                nameLabel.text = p.nombre
            }
        }else{
            
            cell = tableView.dequeueReusableCell(withIdentifier: "NoFavoriteCell", for: indexPath)
            
            let p = ParqueaderosNoFav[indexPath.row] as Parqueadero
            
            if let nameLabel = cell.viewWithTag(101) as? UILabel {
                nameLabel.text = p.nombre
            }
        }

        return cell
    }
    
    func loadFav(u:String){
        let jsonUser = "{\"id\":"+u+"}"
        client.post(url: "http://192.168.128.30:8080/parqueaderos/fav", json:jsonUser, callback: processFav)
    }
    
    
    func loadParqueaderos(){
        let client:HttpClient = HttpClient()
        client.get(url: "http://192.168.128.30:8080/parqueaderos/calif", callback: processData)
    }
    
    func processFav(data:Data?){
        do{
            let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            
            let success:Bool = json.value(forKey: "success") as! Bool
            if success == true {
                let parq:NSArray = json.value(forKey: "parq") as! NSArray
                for i in 0 ..< parq.count{
                    let parq_obj = parq[i] as! NSDictionary
                    let id = parq_obj["id_parqueadero"] as! Int
                    idParq.append(id)
                }
            }
        }catch{}
    }
    
    func processData(data:Data?){
        
        do{
            let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            
            let success:Bool = json.value(forKey: "success") as! Bool
            //if success == true {
                var z:Bool
                let parq:NSArray = json.value(forKey: "parq") as! NSArray
                for i in 0 ..< parq.count{
                    z = false
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
                    if success == true {
                    for j in idParq{
                        if j == id {
                            z = true
                        }
                    }
                    if z == true{
                        ParqueaderosFav.append(p)
                    }else{
                        ParqueaderosNoFav.append(p)
                    }
                    }else{
                        ParqueaderosNoFav.append(p)
                    }
                }
            //}
        }catch{}
        DispatchQueue.main.async {
            self.Favorite.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            let p:Parqueadero = ParqueaderosFav[indexPath.row]
            let mensaje:String = "Desea eliminar el Parqueadero "+p.nombre!+" de la seccion de favoritos"
            let alertController = UIAlertController(title: "Eliminar favorito", message:
                mensaje, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Eliminar", style: UIAlertActionStyle.default,handler: {
                (result : UIAlertAction) -> Void in
                var jsonUser = "{\"idu\":"+String(self.userID)
                jsonUser += ",\"idp\":"+String(p.id)+"}"
                self.client.post(url: "http://192.168.128.30:8080/parqueaderos/favr", json:jsonUser, callback: self.processFavr)
                for (index, value) in self.ParqueaderosFav.enumerated() {
                    if p.id == value.id{
                        self.ParqueaderosFav.remove(at: index)
                        self.ParqueaderosNoFav.append(p)
                    }
                }
            }))
            //Cancel button action
            let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }else{
            let p:Parqueadero = ParqueaderosNoFav[indexPath.row]
            let mensaje:String = "Desea agregar el Parqueadero "+p.nombre!+" a la seccion de favoritos"
            let alertController = UIAlertController(title: "Agregar favorito", message:
                mensaje, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Agregar", style: UIAlertActionStyle.default,handler: {
                (result : UIAlertAction) -> Void in
                var jsonUser = "{\"id\":"+String(self.userID)
                jsonUser += ",\"parqueadero\":"+String(p.id)+"}"
                self.client.post(url: "http://192.168.128.30:8080/parqueaderos/fava", json:jsonUser, callback: self.processFava)
                for (index, value) in self.ParqueaderosNoFav.enumerated() {
                    if p.id == value.id{
                        self.ParqueaderosNoFav.remove(at: index)
                        self.ParqueaderosFav.append(p)
                    }
                }
            }))
            
            //Cancel button action
            let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
        }
    }

    func processFavr(data:Data?){
        do{
            let json1:NSDictionary
            json1 = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            let success:Bool = json1.value(forKey: "success") as! Bool
            if success == true {
                DispatchQueue.main.async {
                    self.Favorite.reloadData()
                }
            }
        }catch{}
        
        DispatchQueue.main.async {
            self.Favorite.reloadData()
        }
        
    }
    
    func processFava(data:Data?){
        do{
            let json1:NSDictionary
            json1 = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            let success:Bool = json1.value(forKey: "success") as! Bool
            if success == true {
                DispatchQueue.main.async {
                    self.Favorite.reloadData()
                }
            }
        }catch{}
        DispatchQueue.main.async {
            self.Favorite.reloadData()
        }
    }
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
