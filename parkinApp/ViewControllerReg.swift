//
//  ViewControllerReg.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 16/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation
import UIKit

class ViewControllerReg: UIViewController{
    @IBOutlet var nombre: UITextField!
    @IBOutlet var usu: UITextField!
    @IBOutlet var pass: UITextField!
    
    @IBAction func registro(_ sender: Any) {
        self.insertar()
        
    }
    let client:HttpClient = HttpClient()
    
    var user:Usuario?
    var dao:UsuarioDAO!

    override func viewDidLoad() {
        super.viewDidLoad()
        dao = UsuarioDAO()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func insertar(){
        let n = nombre.text!
        let u = usu.text!
        let p = pass.text!
        
        let jsonUser = "{\"nombres\": \""+n+"\",\"user\":\""+u+"\",\"password\":\""+p+"\"}"
        client.post(url: "http://192.168.128.30:8080/usuarios/", json: jsonUser, callback: processData)
    }
    
    func processData(data:Data?){
        
        do{
            let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            
            let success:Bool = json.value(forKey: "success") as! Bool
            if success == true {
                let alertController = UIAlertController(title: "Registro valido", message:
                  "Vuelva al inicio de sesión", preferredStyle: UIAlertControllerStyle.alert)
                alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default,handler: nil))
                DispatchQueue.main.async {
                    self.present(alertController, animated: true, completion: nil)
                }
                
            }else{
                //let alertController = UIAlertController(title: "Datos errados", message:
                //  "Por favor valide sus datos", preferredStyle: UIAlertControllerStyle.alert)
                //alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default,handler: nil))
                //self.present(alertController, animated: true, completion: nil)
            }
        }catch{}
    }
    
    
}

