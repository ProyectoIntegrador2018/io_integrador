//
//  PacientViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 3/20/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

class PatientViewController: UIViewController {
    var patient: Patient!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMedicalRecord()
    }
    
    func getMedicalRecord() {
        ApiClient.shared.getMedicalRecord(patientId: patient.id) { (result) in
            switch result {
            case let .success(medicalRecord):
                self.patient.medicalRecord = medicalRecord
                self.updateLayout()
            case let .error(error):
                self.alert(message: error, title: "Error")
            }
        }
    }
    
    func updateLayout() {
    }
    
}
