//
//  PacientsViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import Presentr

class PacientsViewController: UIViewController {

    var pinCodeView: PinCodeView!
    var pin = [Character]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

}

// MARK: - Local Authorization

extension PacientsViewController: PinCodeDelegate {
    
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
