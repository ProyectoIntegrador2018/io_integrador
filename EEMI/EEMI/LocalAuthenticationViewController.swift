//
//  BiometricLoginViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import LocalAuthentication

class LocalAuthenticationViewController: UIViewController {

    @IBOutlet weak var pinCodeView: PinCodeView!
    
    var context = LAContext()

    override func viewDidLoad() {
        super.viewDidLoad()
        pinCodeView.delegate = self
        context.canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
        localAuthentication()
        
    }
    
    func localAuthentication() {
        
        context = LAContext()
        context.localizedCancelTitle = "Cancel"
        
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Iniciar sesion a tu cuenta"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    DispatchQueue.main.async {
                        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                        let viewController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
                        UIApplication.shared.keyWindow?.rootViewController = viewController
                    }
                } else {
                    print(error?.localizedDescription ?? "Failed to authenticate")
                    // Fall back to a asking for username and password.
                }
            }
        } else {
            print(error?.localizedDescription ?? "Can't evaluate policy")
            // Fall back to a asking for username and password.
        }
        
    }
    
}

extension LocalAuthenticationViewController: PinCodeDelegate {
    func didSelectButton(number: Int) {
        //TODO: Manage selected buttons
    }
    
    func didSelectDelete() {
        //TODO: Manage delete button
    }
    
}
