//
//  AgendaViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

class AgendaViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getAppointments() {
        let dateInterval = DateInterval(start: Date(), end: Date(timeInterval: 86400*5, since: Date()))
        ApiClient.shared.getAppointments(dateInterval: dateInterval) { (result) in
            switch result {
            case let .success(appointments):
                print("Appointment count: " + String(appointments.count))
            case let .error(error):
                print("Error: " + error.debugDescription)
            }
        }
    }
    
}
