//
//  PinViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 3/26/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

class PinViewController: UIViewController {

    @IBOutlet weak var actualPin: UITextField!
    @IBOutlet weak var newPin: UITextField!
    @IBOutlet weak var changePinButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout() {
        changePinButton.layer.cornerRadius = changePinButton.frame.height/5
    }
    
    func alertMessage(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: finishAlert)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    func finishAlert(alert: UIAlertAction!) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Actions
    
    @IBAction func changePin(_ sender: UIButton) {
        
        guard actualPin.text == User.shared.pin else {
            alert(message: "Intente de nuevo", title: "Pin actual incorrecto")
            return
        }
        
        User.shared.savePin(pin: newPin.text!)
        alertMessage(message: "Puedes usar el nuevo pin para iniciar secion", title: "Pin salvado correctamente")

    }
}
