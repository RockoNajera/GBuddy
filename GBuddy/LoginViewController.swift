//
//  LoginViewController.swift
//  GBuddy
//
//  Created by Rodrigo Nájera Rivas on 5/8/17.
//  Copyright © 2017 Yooko. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    // MARK: Constants
    let loginToList = "LoginToList"
    
    // MARK: Outlets
    @IBOutlet weak var textFieldLoginEmail: UITextField!
    @IBOutlet weak var textFieldLoginPassword: UITextField!
    
    override func viewDidLoad() {
        
        // 1
        FIRAuth.auth()!.addStateDidChangeListener() { auth, user in
            // 2
            if user != nil {
                // 3
            }
        }
        
    }
    
    // MARK: Actions
    @IBAction func loginDidTouch(_ sender: AnyObject) {
        FIRAuth.auth()!.signIn(withEmail: textFieldLoginEmail.text!,
                               password: textFieldLoginPassword.text!)
        self.presentViewController()
    }
    
    @IBAction func signUpDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "¿No tienes una cuenta?",
                                      message: "Registrate",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Save",
                                       style: .default) { action in
                                        
        // 1
        let emailField = alert.textFields![0]
        let passwordField = alert.textFields![1]
                                        
        // 2
        FIRAuth.auth()!.createUser(withEmail: emailField.text!,
        password: passwordField.text!) { user, error in
            if error == nil {
                
                // 3
                FIRAuth.auth()!.signIn(withEmail: self.textFieldLoginEmail.text!,
                password: self.textFieldLoginPassword.text!)
                                                                        
                    self.presentViewController()
                
                }
            }
                                        
        }
        
        let cancelAction = UIAlertAction(title: "Cancel",
                                         style: .default)
        
        alert.addTextField { textEmail in
            textEmail.placeholder = "Enter your email"
        }
        
        alert.addTextField { textPassword in
            textPassword.isSecureTextEntry = true
            textPassword.placeholder = "Enter your password"
        }
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func presentViewController(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let viewController = storyboard.instantiateViewController(withIdentifier :"Main")
        self.present(viewController, animated: true)
    }
    
}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == textFieldLoginEmail {
            textFieldLoginPassword.becomeFirstResponder()
        }
        if textField == textFieldLoginPassword {
            textField.resignFirstResponder()
        }
        return true
    }
    
}
