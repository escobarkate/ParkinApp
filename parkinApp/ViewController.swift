//
//  ViewController.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 14/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var nombreUsuario: UITextField!
    
    @IBOutlet var contraseña: UITextField!
    
    var user:Usuario?
    var dao:UsuarioDAO!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dao = UsuarioDAO()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToTabs(_ sender: Any) {
        let client:HttpClient = HttpClient()
        let usu = nombreUsuario.text!
        let contra = contraseña.text!
        
        let jsonUser = "{\"user\":\""+usu+"\",\"password\":\""+contra+"\"}"
        client.post(url: "http://192.168.128.30:8080/usuarios/login/", json: jsonUser, callback: processData)
        
        
         }
    
    @IBAction func backToInit(_ segue: UIStoryboardSegue) {
        }

    
    @IBAction func goToRegistrar(_ sender: Any) {
        performSegue(withIdentifier: "reg", sender: nil)     }
    
    
    func processData(data:Data?){
        
        do{
            let json:NSDictionary = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as! NSDictionary
            
            let success:Bool = json.value(forKey: "success") as! Bool
            if success == true {
                let usr:NSDictionary = json.value(forKey: "user") as! NSDictionary
                let id = usr["id"] as! Int
                let nombre = usr["nombres"] as! String
                let usu = usr["user"] as! String
                let us = Usuario()
                us.id = Int64(id)
                us.nombre = nombre
                us.user = usu
                dao.deleteAll()
                dao.insert(u: us)
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "next", sender: nil)
                }
            }else{
                //let alertController = UIAlertController(title: "Datos errados", message:
                  //  "Por favor valide sus datos", preferredStyle: UIAlertControllerStyle.alert)
                //alertController.addAction(UIAlertAction(title: "Aceptar", style: UIAlertActionStyle.default,handler: nil))
                //self.present(alertController, animated: true, completion: nil)
            }
        }catch{}
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





}

