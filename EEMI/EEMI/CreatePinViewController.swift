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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
    }
    
    func layout() {
        changePin.layer.cornerRadius = changePin.frame.height/5
    }
    
    @IBAction func ChangePin(_ sender: UIButton) {
        
        view.endEditing(true)
        guard pinTextField.text?.count == 4 else {
            return
        }
        
        User.shared.savePin(pin: pinTextField.text!)
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
        UIApplication.shared.keyWindow?.rootViewController = viewController
        
    }
}
