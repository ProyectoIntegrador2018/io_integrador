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
    var pin: String?
    var isAuthenticationOn = false {
        didSet {
            self.saveAuthenticationOption(auth: isAuthenticationOn)
        }
    }
    
    private init() {
        isAuthenticationOn = retriveAuthenticationOption()
        if let retrivedToken = retriveToken() {
            token = retrivedToken
        }
        
        if let retrivedPin = retrivePin() {
            pin = retrivedPin
        }
    }
    
    func save(token: String) {
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        keychain["user"] = token
        self.token = token
    }
    
    func retriveToken() -> String? {
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        let token = keychain["user"]
        return token
    }
    
    func savePin(pin: String) {
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        keychain["pin"] = pin
        self.pin = pin
    }
    
    func retrivePin() -> String? {
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        let pin = keychain["pin"]
        return pin
    }
    
    func saveAuthenticationOption(auth: Bool) {
        UserDefaults.standard.set(true, forKey: "isAuthenticationOn")
    }
    
    func retriveAuthenticationOption() -> Bool {
        return UserDefaults.standard.bool(forKey: "isAuthenticationOn")
    }
}
