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

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification ,
                                               object: nil)
        
    }
    
    @objc func appWillEnterForeground() {

    }
    
    @IBAction func logout(_ sender: UIButton) {
        //Remove notification observer
        User.shared.token = nil
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        keychain["user"] = nil
        
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        view.window!.rootViewController = viewController
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
