//
//  SettingsViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import KeychainAccess
import Presentr

class SettingsViewController: UIViewController {
    
    var pinCodeView: PinCodeView!
    var pin = [Character]()
    
    @IBOutlet weak var changePin: UIView!
    @IBOutlet weak var disableAuthenticationSwitch: UISwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        updateLayout()
    }
    
    func updateLayout() {
        if User.shared.isAuthenticationOn {
            disableAuthenticationSwitch.isOn = true
            changePin.isHidden = false

        } else {
            disableAuthenticationSwitch.isOn = false
            changePin.isHidden = true
        }
    }
    
    // MARK: - Actions
    
    @IBAction func logout(_ sender: UIButton) {
        User.shared.token = nil
        User.shared.pin = nil
        User.shared.isAuthenticationOn = false
        let keychain = Keychain(service: "emmiapi.azurewebsites.net")
        keychain["user"] = nil
        keychain["pin"] = nil
        
        NotificationCenter.default.removeObserver(tabBarController!, name: UIApplication.willEnterForegroundNotification, object: nil)
        
        let storyboard = UIStoryboard(name: "Login", bundle: Bundle.main)
        let viewController = storyboard.instantiateViewController(withIdentifier: "LoginViewController")
        view.window!.rootViewController = viewController
    }
    
    @IBAction func changePin(_ sender: UITapGestureRecognizer) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "PinViewController") as! PinViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func helpAndLegal(_ sender: UITapGestureRecognizer) {
        
    }
    
    @IBAction func authenticationSwitch(_ sender: UISwitch) {
        if sender.isOn {
            User.shared.isAuthenticationOn = true
            let presenter = Presentr(presentationType: PresentationType.fullScreen)
            let storyboard = UIStoryboard(name: "Login", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "CreatePinViewController") as! CreatePinViewController
            customPresentViewController(presenter, viewController: vc, animated: true)
        } else {
            User.shared.isAuthenticationOn = false
        }
        updateLayout()
    }
}

// MARK: - Local Authorization

extension SettingsViewController: PinCodeDelegate {
    
    func didSelectForgotPin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPinViewController") as! ForgotPinViewController
        let presenter: Presentr = {
            let width = ModalSize.fluid(percentage: 0.8)
            let height = ModalSize.fluid(percentage: 0.4)
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            let customPresenter = Presentr(presentationType: customType)
            return customPresenter
        }()
        self.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
    }
    
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
