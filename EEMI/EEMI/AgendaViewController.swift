//
//  AgendaViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import LocalAuthentication

class AgendaViewController: UIViewController {
    
    var pinCodeView: PinCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification ,
                                               object: nil)

        if User.shared.token != nil {
            pinCodeView = PinCodeView(frame: view.frame)
            tabBarController?.view.addSubview(pinCodeView)
            pinCodeView.delegate = self
            localAuthentication(fallbackView: pinCodeView)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       
    }
    
    @objc func appWillEnterForeground() {
        tabBarController?.view.addSubview(pinCodeView)
        localAuthentication(fallbackView: pinCodeView)
    }
    
}

// MARK: - Local Authorization

extension AgendaViewController: PinCodeDelegate {
    func didSelectButton(number: Int) {
        pinCodeView.removeFromSuperview()
    }
    
    func didSelectDelete() {
    }
}
