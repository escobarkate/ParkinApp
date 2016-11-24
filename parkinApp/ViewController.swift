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
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
        client.post(url: "http://192.168.1.30:8080/usuarios/login/", json: jsonUser, callback: processData)
        
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
                //let usuario:NSDictionary = json.object(forKey: "user") as! NSDictionary
                //let nombres:NSDictionary = usuario.object(forKey: "nombres") as! NSDictionary
                //let usr:NSDictionary = usuario.object(forKey: "user") as! NSDictionary
                
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: "next", sender: nil)
                }
                
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

