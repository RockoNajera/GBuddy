//
//  ExercisesTableViewController.swift
//  GBuddy
//
//  Created by Rodrigo Nájera Rivas on 5/9/17.
//  Copyright © 2017 Yooko. All rights reserved.
//

import UIKit
import Firebase

class ExercisesTableViewController: UITableViewController {


    
    // MARK: Properties
    var items: [routineItem] = []
    var user: User!
    var userCountBarButtonItem: UIBarButtonItem!
    let ref = FIRDatabase.database().reference(withPath: "routine-items")
    let usersRef = FIRDatabase.database().reference(withPath: "online")
    var isUser: Bool?
    
    //MARK: Outlets
    @IBOutlet weak var addExerciseButton: UIBarButtonItem!
    
    
    
    
    // MARK: UIViewController Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.allowsMultipleSelectionDuringEditing = false
        
        userCountBarButtonItem = UIBarButtonItem(title: "< Atras",
                                                 style: .plain,
                                                 target: self,
                                                 action: #selector(userCountButtonDidTouch))
        userCountBarButtonItem.tintColor = UIColor.black
        navigationItem.leftBarButtonItem = userCountBarButtonItem
        
        user = User(uid: "InitUser", email: "userInit@test.com")
        
        ref.queryOrdered(byChild: "completed").observe(.value, with: { snapshot in
            var newItems: [routineItem] = []
            
            for item in snapshot.children {
                let groceryItem = routineItem(snapshot: item as! FIRDataSnapshot)
                newItems.append(groceryItem)
            }
            
            // 1
            let currentUserRef = self.usersRef.child(self.user.uid)
            // 2
            currentUserRef.setValue(self.user.email)
            // 3
            currentUserRef.onDisconnectRemoveValue()
            
            self.items = newItems
            self.tableView.reloadData()
            
            FIRAuth.auth()!.addStateDidChangeListener { auth, user in
                guard let user = user else { return }
                self.user = User(authData: user)
            }
            
            
        })
        
//        usersRef.observe(.value, with: { snapshot in
//            if snapshot.exists() {
//                self.userCountBarButtonItem?.title = snapshot.childrenCount.description
//            } else {
//                self.userCountBarButtonItem?.title = "0"
//            }
//        })
        
        
        
        isUser = true
        
        if isUser == true {
            
            self.addExerciseButton.title = ""
            
        }
        
    }
    
    // MARK: UITableView Delegate methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath)
        let groceryItem = items[indexPath.row]
        
        cell.textLabel?.text = groceryItem.name
        cell.detailTextLabel?.text = groceryItem.addedByUser
        
        toggleCellCheckbox(cell, isCompleted: groceryItem.completed)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let groceryItem = items[indexPath.row]
            groceryItem.ref?.removeValue()
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 1
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        // 2
        let groceryItem = items[indexPath.row]
        // 3
        let toggledCompletion = !groceryItem.completed
        // 4
        toggleCellCheckbox(cell, isCompleted: toggledCompletion)
        // 5
        groceryItem.ref?.updateChildValues([
            "completed": toggledCompletion
            ])
    }
    
    func toggleCellCheckbox(_ cell: UITableViewCell, isCompleted: Bool) {
        if !isCompleted {
            cell.accessoryType = .none
            cell.textLabel?.textColor = UIColor.black
            cell.detailTextLabel?.textColor = UIColor.black
        } else {
            cell.accessoryType = .checkmark
            cell.textLabel?.textColor = UIColor.gray
            cell.detailTextLabel?.textColor = UIColor.gray
        }
    }
    
    // MARK: Add Item
    
    @IBAction func addButtonDidTouch(_ sender: AnyObject) {
        let alert = UIAlertController(title: "Nuevo ejercicio",
                                      message: "Agregue un nuevo ejercicio a la rutina",
                                      preferredStyle: .alert)
        
        let saveAction = UIAlertAction(title: "Guardar",
                                       style: .default) { action in
                                        
                                        // 1
                                        guard let textField = alert.textFields?.first, let text = textField.text else { return }
                                        
                                        // 2
                                        let groceryItem = routineItem(name: text, addedByUser: self.user.email, completed: false)
                                        
                                        // 3
                                        let groceryItemRef = self.ref.child(text.lowercased())
                                        
                                        // 4
                                        groceryItemRef.setValue(groceryItem.toAnyObject())
                                        
                                        self.items.append(groceryItem)
                                        self.tableView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancelar",
                                         style: .default)
        
        alert.addTextField()
        
        alert.addAction(saveAction)
        alert.addAction(cancelAction)
        
        present(alert, animated: true, completion: nil)
    }
    
    func userCountButtonDidTouch() {
        if let navController = self.navigationController {
            navController.popViewController(animated: true)
        }
    }
}
