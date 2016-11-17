//
//  ViewController.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 14/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var nombreUsuario: UITextField!
    
    @IBOutlet weak var contraseña: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func goToTabs(_ sender: Any) {
        performSegue(withIdentifier: "next", sender: nil)    }

    
    @IBAction func goToRegistrar(_ sender: Any) {
        performSegue(withIdentifier: "reg", sender: nil)     }
}

