//
//  User.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import Foundation
import KeychainAccess

class User {
    
    static var shared = User()
    var token: String?
    var pin: String = "1234"
    
    private init() {
        
        if let retrivedToken = retriveToken() {
            token = retrivedToken
        }
    }
    
    func save(token: String) {
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        keychain["user"] = token
        self.token = token
    }
    
    func retriveToken() -> String? {
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        let token =  keychain["user"]
        return token
    }
    
    func savePin(pin: String) {
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        keychain["pin"] = pin
        self.pin = pin
    }
    
    func retrivePin() -> String? {
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        let pin =  keychain["pin"]
        return pin
    }
}
