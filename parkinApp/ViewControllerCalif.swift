//
//  ViewControllerCalif.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 21/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

/*class ViewControllerCalif: UIViewController, UITableViewDataSource, UITableViewDelegate {
    let parqs=["Parqueadero 1", "Parqueadero 2", "Parqueadero 3"]

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (parqs.count)
    }
    

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        var cell: UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        //tableView.dequeueReusableCell(withIdentifier: "cell", for: <#T##IndexPath#>) as! ViewControllerTableViewCell
        //cell.image.image = UIImage(named: "Catedral-Basílica-de-Nuestra-Señora-de-la-Asunción-de-Popayán-Colombia-1.jpg")
        cell?.textLabel?.text = parqs[indexPath.row]
        return (cell!)
    }
}*/

class ViewControllerCalif: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var data: [String]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cliente:HttpClient = HttpClient()
        data = []
        data.append("Rojo")
        data.append("Azul")
        data.append("Amarillo")
        data.append("Verde")
        
        cliente.get(url: "http://192.168.0.23:8080/parqueaderos/calif", callback: processData)
        
    }
    
    func processData(data:Data?){
        
        do{
            let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            
            let success:Bool = json.value(forKey: "success") as! Bool
            if success == true {
                
    
                
                //let usuario:NSDictionary = json.object(forKey: "user") as! NSDictionary
                //let nombres:NSDictionary = usuario.object(forKey: "nombres") as! NSDictionary
                //let usr:NSDictionary = usuario.object(forKey: "user") as! NSDictionary
                
            }else{
                
            }
        }catch{}
        
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //  MARK: - Methods Data Source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell:UITableViewCell? = tableView.dequeueReusableCell(withIdentifier: "celda")
        
        if cell == nil {
            
            cell = UITableViewCell(style: .default, reuseIdentifier: "celda")
            
        }
        
        cell?.textLabel?.text = data[indexPath.row]
        
        return cell!
    }
    
    
    //MARK: - Methods Delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let alert = UIAlertController(title: "Color", message: "Color seleccionado "+data[indexPath.row], preferredStyle: .alert)
        
        let cerrar = UIAlertAction(title: "Cerrar", style: .cancel, handler: nil)
        
        let eliminar = UIAlertAction(title: "Eliminar", style: .default){
            (action:UIAlertAction) in
            
            self.data.remove(at: indexPath.row)
            tableView.reloadData()
        }
        
        alert.addAction(cerrar)
        alert.addAction(eliminar)
        
        present(alert, animated: true, completion: nil)
    }
    
}




/*class ViewControllerCalif: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let cliente:HttpClient = HttpClient()
        cliente.get(url: "http://192.168.0.23:8080/parqueaderos/calif", callback: processData)
    }
    
 
    
    func JSONStringify(value: AnyObject,prettyPrinted:Bool = false) -> String{
        
        let options = prettyPrinted ? JSONSerialization.WritingOptions.prettyPrinted : JSONSerialization.WritingOptions(rawValue: 0)
        
        
        if JSONSerialization.isValidJSONObject(value) {
            
            do{
                let data = try JSONSerialization.data(withJSONObject: value, options: options)
                if let string = NSString(data: data, encoding: String.Encoding.utf8.rawValue) {
                    return string as String
                }
            }catch {
                
                print("error")
                //Access error here
            }
            
        }
        return ""
        
    }

    
    
    var fruits = ["Apple", "Apricot", "Banana", "Blueberry", "Cantaloupe", "Cherry",
                  "Clementine", "Coconut", "Cranberry", "Fig", "Grape", "Grapefruit",
                  "Kiwi fruit", "Lemon", "Lime", "Lychee", "Mandarine", "Mango",
                  "Melon", "Nectarine", "Olive", "Orange", "Papaya", "Peach",
                  "Pear", "Pineapple", "Raspberry", "Strawberry"]
    
    // MARK: - UITableViewDataSource
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return fruits.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LabelCell", for: indexPath)
        
        let fruitName = fruits[indexPath.row]
        cell.textLabel?.text = fruitName
        cell.detailTextLabel?.text = "Delicious!"
        cell.imageView?.image = UIImage(named: fruitName)
        
        return cell
    }
    
}
*/

