//
//  CreatePinViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 3/26/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

class CreatePinViewController: UIViewController {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var pinTextField: UITextField!
    @IBOutlet weak var changePin: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pinTextField.becomeFirstResponder()
        pinTextField.delegate = self
        layout()
    }
    
    func layout() {
        changePin.layer.cornerRadius = changePin.frame.height/5
        cancelButton.layer.cornerRadius = cancelButton.frame.height/5
    }
    
    @IBAction func ChangePin(_ sender: UIButton) {
        
        view.endEditing(true)
        guard pinTextField.text?.count == 4 else {
            return
        }
        
        User.shared.savePin(pin: pinTextField.text!)
        User.shared.isAuthenticationOn = true
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
    }
    @IBAction func cancel(_ sender: UIButton) {
        view.endEditing(true)
        User.shared.isAuthenticationOn = false
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
        UIApplication.shared.keyWindow?.rootViewController = viewController
    }
    
    @IBAction func removeKeyboard(_ sender: Any) {
        view.endEditing(true)
    }
    
}

extension CreatePinViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        let newLength = text.count + string.count - range.length
        return newLength <= 4
    }
}
