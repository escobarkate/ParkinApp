//
//  PlayersViewController.swift
//  parkinApp
//
//  Created by cdt creatic on 23/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class PlayersTableViewController: UITableViewController {
    
    var dao:UsuarioDAO!
    let client:HttpClient = HttpClient()
    var user:[Usuario] = []
    
    
    @IBOutlet var Calificar: UITableView!
    var ParqueaderosData: [Parqueadero] = [Parqueadero]()
    var idParq:[Int] = []
    var c:[Double] = []
    var userID:Int!
    
    var label:UILabel!
    var slider:UISlider!
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.tabBarController?.navigationItem.title = "Calificar parqueaderos"
        dao = UsuarioDAO()
        user = dao.all()
        print(user);
        print(user[0].id)
        userID = Int(user[0].id)
        loadParqueaderos()
        loadCalif(u: String(user[0].id))
        DispatchQueue.main.async {
            self.Calificar.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //loadParqueaderos()
        Calificar.reloadData()
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let p:Parqueadero = ParqueaderosData[indexPath.row]
        var z:Bool = false
        var s:Int = 0
        
        for (index, value) in idParq.enumerated() {
            if p.id == value{
                z = true
                s = index
            }
        }
        if z == true {
            let mensaje:String = "Usted ya ha calificado el Parqueadero "+p.nombre!+" con una calificación de "+String(c[s])
            let alertController = UIAlertController(title: "Calificar parqueadero", message:
                mensaje, preferredStyle: UIAlertControllerStyle.alert)
            alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default,handler: nil))
            self.present(alertController, animated: true, completion: nil)
        }else{
            
            //get the Slider values from UserDefaults
            let defaultSliderValue = UserDefaults.standard.float(forKey: "sliderValue")
            
            //create the Alert message with extra return spaces
            let sliderAlert = UIAlertController(title: "Calificar Parqueadero", message: "Usted no ha calificado el Parqueadero "+p.nombre!+".\n\n\n\n", preferredStyle: .alert)
            
            //create a Slider and fit within the extra message spaces
            //add the Slider to a Subview of the sliderAlert
            slider = UISlider(frame:CGRect(x: 20, y: 100, width: 230, height: 80))
            slider.minimumValue = 1
            slider.maximumValue = 5
            slider.value = defaultSliderValue
            slider.addTarget(self, action: #selector(PlayersTableViewController.sliderChanged), for:.valueChanged)
            slider.isContinuous = true
            slider.tintColor = UIColor.red
            UserDefaults.standard.didChangeValue(forKey: "sliderValue")
            sliderAlert.view.addSubview(slider)
            
            //Crear label
            label = UILabel(frame:CGRect(x: 123, y: 70, width: 50, height: 80))
            label.text = String(Int((slider.value)))
            sliderAlert.view.addSubview(label)
            
            //OK button action
            let sliderAction = UIAlertAction(title: "Calificar", style: .default, handler: { (result : UIAlertAction) -> Void in
                var jsonUser = "{\"user\":"+String(self.userID)
                jsonUser += ",\"parqueadero\":\""+String(p.id)
                jsonUser += "\",\"calificacion\":\""+String(Int(self.slider.value))+"\"}"
                self.client.post(url: "http://192.168.128.30:8080/parqueaderos/cali", json: jsonUser, callback: self.processCalif)
                let x = Float(p.calificacion)+Float(Int(self.slider.value))
                
                let a = Float(p.cantidad)+1
                let suma = (x/a)*10
                let suma1 = Int(suma)
                let suma2 = suma1/10
                var json = "{\"id\":"+String(p.id)
                json += ",\"cantidad\":"+String(Int(a))
                json += ",\"calificacion\":\""+String(suma2)+"\"}"
                self.client.post(url: "http://192.168.128.30:8080/parqueaderos/cf", json: json, callback: self.processCf)
            })
            
            //Cancel button action
            let cancelAction = UIAlertAction(title: "Cancelar", style: .destructive, handler: nil)
            
            //Add buttons to sliderAlert
            sliderAlert.addAction(sliderAction)
            sliderAlert.addAction(cancelAction)
            
            //present the sliderAlert message
            self.present(sliderAlert, animated: true, completion: nil)
        }
    }
    
    func sliderChanged(){
        label.text = String(Int((slider.value)))
    }
    
    func loadParqueaderos(){
        client.get(url: "http://192.168.128.30:8080/parqueaderos/calif", callback: processData)
    }
    
    func loadCalif(u:String){
        let jsonUser = "{\"id\":"+u+"}"
        print(jsonUser)
        client.post(url: "http://192.168.128.30:8080/parqueaderos/caliUser", json:jsonUser, callback: processData2)
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
    
    func processData2(data:Data?){
        do{
            let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            
            let success:Bool = json.value(forKey: "success") as! Bool
            if success == true {
                let parq:NSArray = json.value(forKey: "parq") as! NSArray
                for i in 0 ..< parq.count{
                    let parq_obj = parq[i] as! NSDictionary
                    let id = parq_obj["idParqueadero"] as! Int
                    let cal = parq_obj["calificacion"] as! Double
                    idParq.append(id)
                    c.append(cal)
                }
            }
        }catch{}
        DispatchQueue.main.async {
            self.Calificar.reloadData()
        }
    }
    
    func processCalif(data:Data?){
        do{
            let json1:NSDictionary
            json1 = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            let success:Bool = json1.value(forKey: "success") as! Bool
            if success == true {
                DispatchQueue.main.async {
                    self.Calificar.reloadData()
                }
            }
        }catch{}
        
    }

    func processCf(data:Data?){
        do{
            let json1:NSDictionary
            json1 = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            let success:Bool = json1.value(forKey: "success") as! Bool
            if success == true {
                self.ParqueaderosData = []
                loadParqueaderos()
                loadCalif(u: String(userID))
                DispatchQueue.main.async {
                    self.Calificar.reloadData()
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
