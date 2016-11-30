//
//  InfoParqueaderoTableViewController.swift
//  parkinApp
//
//  Created by cdt creatic on 29/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class InfoParqueaderoTableViewController: UITableViewController {
    
    @IBOutlet var Informacion: UITableView!
    var Parqueaderos:Parqueadero? = nil
    let client:HttpClient = HttpClient()

    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            self.Informacion.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        Informacion.reloadData()
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
        return 1
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        
        if let nombreLabel = cell.viewWithTag(100) as? UILabel {
            nombreLabel.text = Parqueaderos?.nombre
        }
        
        if let dirLabel = cell.viewWithTag(101) as? UILabel {
            dirLabel.text = Parqueaderos?.direccion
        }
        if let precioLabel = cell.viewWithTag(102) as? UILabel {
            precioLabel.text = Parqueaderos?.precio
        }
        
        if let puestosLabel = cell.viewWithTag(103) as? UILabel {
            let lug:String = ""+String(describing: Parqueaderos?.lugareslibres)
            puestosLabel.text = lug
        }
        
        if let ImageView = cell.viewWithTag(105) as? UIImageView {
            ImageView.image = self.imagen(parq: Parqueaderos!.imagen!)
            
        }
        return cell
    }
    
    func imagen(parq:String) ->UIImage? {
        let imageName = "\(parq)"
        return UIImage(named: imageName)
    }
}
