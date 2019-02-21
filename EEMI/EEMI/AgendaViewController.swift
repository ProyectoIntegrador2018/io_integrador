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
        
        // Do any additional setup after loading the view, typically from a nib.
        
        fetchAppointments()
    }
    
    func fetchAppointments() {
        let interval = DateInterval(start: Date(), end: Date())
        ApiClient.shared.getAppointments(dateInterval: interval) { (result) in
            switch result {
            case let .success(appointments):
                print(appointments)
            case let .error(error):
                print("Error:" + error)
            }
        }
    }

}
