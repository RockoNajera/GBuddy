//
//  User.swift
//  GBuddy
//
//  Created by Rodrigo Nájera Rivas on 5/8/17.
//  Copyright © 2017 Yooko. All rights reserved.
//

import Foundation
import Firebase

struct User {
    
    let uid: String
    let email: String
    
    init(authData: FIRUser) {
        uid = authData.uid
        email = authData.email!
    }
    
    init(uid: String, email: String) {
        self.uid = uid
        self.email = email
    }
    
}
