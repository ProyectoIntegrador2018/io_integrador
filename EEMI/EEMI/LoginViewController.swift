//
//  LoginViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import LocalAuthentication
import SkyFloatingLabelTextField

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var passwordTextField: SkyFloatingLabelTextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var loginCredentialsStackView: UIStackView!

    lazy var activityIndicator = ActivityIndicatorView(frame: view.frame, label: "Cargando")
    var pinCodeView: PinCodeView!
    var pin = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()

        if User.shared.token != nil {
            pinCodeView = PinCodeView(frame: view.frame)
            view.addSubview(pinCodeView)
            pinCodeView.delegate = self
            localAuthentication(fallbackView: pinCodeView)
        }

        viewLayout()
    }

    func viewLayout() {
        loginButton.layer.cornerRadius = loginButton.frame.height/2
        KeyboardAvoiding.avoidingView = loginCredentialsStackView
        KeyboardAvoiding.paddingForCurrentAvoidingView = 20

        changeTextFieldColor(field: usernameTextField, fieldTitle: "Usuario")
        changeTextFieldColor(field: passwordTextField, fieldTitle: "Contraseña")

        sumbitButtonEnabled(status: false)

        [usernameTextField, passwordTextField].forEach({ $0.addTarget(self, action: #selector(textViewDidBeginEditing), for: .editingChanged) })

    }

    // MARK: - Actions

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

    // MARK: - Dynamic UI Changes

    func changeTextFieldColor(field: SkyFloatingLabelTextField, fieldTitle: String) {
        field.placeholder = fieldTitle
        field.title = fieldTitle
        field.selectedTitleColor = ColorPallet.primaryColor
        field.selectedLineColor = ColorPallet.primaryColor
    }

    func sumbitButtonEnabled(status: Bool) {
        loginButton.isEnabled = status
        if status {
            loginButton.backgroundColor = ColorPallet.sumbitOrange
        } else {
            loginButton.backgroundColor = ColorPallet.diabledGray
        }
    }

    @objc func textViewDidBeginEditing(_ textField: UITextField) {
        if textField.text?.count == 1 {
            if textField.text?.first == " " {
                textField.text = ""
                return
            }
        }
        guard let username = usernameTextField.text, !username.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
            sumbitButtonEnabled(status: false)
            return
        }
        sumbitButtonEnabled(status: true)
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
        pin.append(Character(String(number)))
        if String(pin) == User.shared.pin {
            pinCodeView.removeFromSuperview()
        }
    }
    
    func didSelectDelete() {
        _ = pin.popLast()
    }
}
