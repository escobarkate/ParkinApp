//
//  PlayersViewController.swift
//  parkinApp
//
//  Created by cdt creatic on 23/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class PlayersTableViewController: UITableViewController {
    
    @IBOutlet var Calificar: UITableView!
    //var Players: [Player] = PlayersData
    let x = Parqueaderos()
    var ParqueaderosData: [Parqueadero] = [Parqueadero]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadParqueaderos()
        Calificar.reloadData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ParqueaderosData.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //loadParqueaderos()
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayerCell", for: indexPath)
        let p = ParqueaderosData[indexPath.row] as Parqueadero
        
        if let nameLabel = cell.viewWithTag(100) as? UILabel {
            nameLabel.text = p.nombre
        }
        
        if let gameLabel = cell.viewWithTag(101) as? UILabel {
            gameLabel.text = p.direccion
        }
        
        if let ratingImageView  = cell.viewWithTag(102) as? UIImageView {
             ratingImageView.image = self.imageForRating(rating: Int(p.calificacion))
        }
        return cell
    }
    
    func imageForRating(rating:Int) ->UIImage? {
        let imageName = "\(rating)Stars"
        return UIImage(named: imageName)
    }
    
    func loadParqueaderos(){
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
                    ParqueaderosData.append(p)
                }
            }
        }catch{}
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
