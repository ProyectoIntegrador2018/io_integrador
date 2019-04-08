//
//  ForgotPinViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 3/27/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import KeychainAccess

class ForgotPinViewController: UIViewController {

    @IBOutlet weak var logoutButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        logoutButton.layer.cornerRadius = logoutButton.frame.height/5
    }

    @IBAction func logout(_ sender: UIButton) {
        User.shared.token = nil
        User.shared.pin = nil
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        keychain["user"] = nil
        keychain["pin"] = nil
        
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        view.window!.rootViewController = viewController
    }
}
