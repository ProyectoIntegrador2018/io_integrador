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
        actualPin.becomeFirstResponder()
        actualPin.delegate = self
        newPin.delegate = self
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
            alert(message: "Intenta de nuevo", title: "Pin actual incorrecto")
            return
        }
        
        User.shared.savePin(pin: newPin.text!)
        alertMessage(message: "Puedes usar el nuevo pin para iniciar sesión", title: "Pin salvado correctamente")

    }
}

extension PinViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4
    }
}
