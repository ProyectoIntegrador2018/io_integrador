//
//  LoginViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import LocalAuthentication

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginCredentialsStackView: UIStackView!
    
    lazy var activityIndicator = ActivityIndicatorView(frame: view.frame, label: "Cargando")
    var pinCodeView: PinCodeView!
      
    override func viewDidLoad() {
        super.viewDidLoad()
       
        if User.shared.token != nil {
            pinCodeView = PinCodeView(frame: view.frame)
            view.addSubview(pinCodeView)
            pinCodeView.delegate = self
            localAuthentication(fallbackView: pinCodeView)
        }
        
        KeyboardAvoiding.avoidingView = loginCredentialsStackView
        KeyboardAvoiding.paddingForCurrentAvoidingView = 20
    }
    
    @IBAction func loginButton(_ sender: UIButton) {
        let username = usernameTextField.text!
        let password = passwordTextField.text!
        
        view.endEditing(true)
        activityIndicator.add(view: view)
        login(username: username, password: password)
    }
    
    @IBAction func dismisKeyboard(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
}

// MARK: - API calls

extension LoginViewController {
    func login(username: String, password: String) {
        ApiClient.shared.getToken(username: username, password: password) { (result) in
            self.activityIndicator.remove()
            switch result {
            case let .success(token):
                User.shared.save(token: token)
                let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                let viewController = storyboard.instantiateViewController(withIdentifier: "MainTabController")
                UIApplication.shared.keyWindow?.rootViewController = viewController
            case let .error(error):
                print("Error: " + error)
                self.alert(message: "Usuario o contraseña invalida", title: "Error")
            }
        }
    }
}

// MARK: - Local Authorization

extension LoginViewController: PinCodeDelegate {
    func didSelectButton(number: Int) {
        //TODO: Manage selected buttons
    }
    
    func didSelectDelete() {
        //TODO: Manage delete button
    }
}
