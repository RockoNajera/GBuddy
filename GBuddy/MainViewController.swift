//
//  ViewController.swift
//  GBuddy
//
//  Created by Rodrigo Nájera Rivas on 5/5/17.
//  Copyright © 2017 Yooko. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {

    
    
    @IBOutlet weak var goToRutinaButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func goToController(_ sender: UIButton) {
        
        let button = sender
        
        print(button.tag)
        
        switch button.tag {
        case 0: presentViewController()
        case 1: presentViewController()
        default: print("The button does not present any view controller")
        }
        
    }
    
    func presentViewController(){
  
        self.performSegue(withIdentifier: "ExercisesTable", sender: nil)
        
    }

}

