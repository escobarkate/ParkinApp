//
//  SearchTableViewController.swift
//  parkinApp
//
//  Created by cdt creatic on 28/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class SearchTableViewController: UITableViewController, UISearchResultsUpdating{
    
    @IBOutlet var Buscar: UITableView!
    var ParqueaderosData: [Parqueadero] = [Parqueadero]()
    let client:HttpClient = HttpClient()
    var nombres:[String] = []
    
    var dao:ParqueaderoDAO!
    
    
    //let items = [String] ()
    var filteredItems = [String]()
    var searchController = UISearchController()
    

    override func viewDidLoad() {
        self.tabBarController?.navigationItem.title = "Buscar parqueaderos"
        super.viewDidLoad()
        dao = ParqueaderoDAO()
        loadParqueaderos()
        searchController = UISearchController(searchResultsController : nil)
        searchController.dimsBackgroundDuringPresentation = true
        self.searchController.searchBar.sizeToFit()
        searchController.searchResultsUpdater = self
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.reloadData()
        DispatchQueue.main.async {
            self.Buscar.reloadData()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier! == "detalle"{
            let detalles:InfoParqueaderoTableViewController = segue.destination as! InfoParqueaderoTableViewController
            //let parqueID = ParqueaderosData[Buscar.indexPathForSelectedRow!.row].id
            //detalles.Parqueaderos = dao.parqById(id: parqueID)
            detalles.Parqueaderos = ParqueaderosData[Buscar.indexPathForSelectedRow!.row]
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchController.isActive{
            return filteredItems.count
        }
        else{
            return nombres.count
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let cell = tableView.dequeueReusableCell(withIdentifier: "itemCell", for: indexPath)
        if searchController.isActive{
            if let nameLabel = cell.viewWithTag(100) as? UILabel {
                nameLabel.text = filteredItems[indexPath.row]
            }
        }else{
            if let nameLabel = cell.viewWithTag(100) as? UILabel {
                nameLabel.text = nombres[indexPath.row]
            }
        }
        return cell
    }
    
  
   
    func updateSearchResults(for searchController: UISearchController) {
        filteredItems.removeAll(keepingCapacity: false)
        filteredItems = nombres.filter{
            item in
            item.lowercased().contains(searchController.searchBar.text!.lowercased())
        }
        tableView.reloadData()
    }
    
    func loadParqueaderos(){
        client.get(url: "http://192.168.128.30:8080/parqueaderos/calif", callback: processData)
    }
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    
        DispatchQueue.main.async {
            self.performSegue(withIdentifier: "detalle", sender: nil)
        }
    
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
                    nombres.append(nombre)
                    dao.insert(p: p)
                }
            }
        }catch{}
        DispatchQueue.main.async {
            self.Buscar.reloadData()
        }
    }


}
