//
//  SettingsViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import KeychainAccess

class SettingsViewController: UIViewController {
    
    var pinCodeView: PinCodeView!
    var pin = [Character]()
    
    @IBOutlet weak var changePin: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    @IBAction func logout(_ sender: UIButton) {
        User.shared.token = nil
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        keychain["user"] = nil
        
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        view.window!.rootViewController = viewController
    }
    
    // MARK: - Actions
    
    @IBAction func changePin(_ sender: UITapGestureRecognizer) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func helpAndLegal(_ sender: UITapGestureRecognizer) {
  
    }
    
}

// MARK: - Local Authorization

extension SettingsViewController: PinCodeDelegate {
    func didSelectButton(number: Int) {
        pin.append(Character(String(number)))
        if String(pin) == User.shared.pin {
            pinCodeView.removeFromSuperview()
        }
    }
    
    func didSelectDelete() {
        _ = pin.popLast()
    }
}
