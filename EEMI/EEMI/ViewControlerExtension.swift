//
//  ViewControlerExtension.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import LocalAuthentication

extension UIViewController {
        
    func alert(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func localAuthentication(fallbackView: UIView) {
        let context = LAContext()
        context.localizedCancelTitle = "Cancelar"
        var error: NSError?
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Iniciar sesión a tu cuenta"
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { success, error in
                if success {
                    DispatchQueue.main.async {
                      fallbackView.removeFromSuperview()
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
