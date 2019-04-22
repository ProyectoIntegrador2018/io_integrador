//
//  AddAppointmentViewController.swift
//  EEMI
//
//  Created by Daniel on 4/22/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

class AddAppointmentViewController: UIViewController {

    var patient: Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addCustomBackButton(title: patient.firstName)
    }
    
    func addCustomBackButton(title: String) {
        let backButton = UIBarButtonItem()
        backButton.title = title
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
}
