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
    lazy var activityIndicator: ActivityIndicatorView = ActivityIndicatorView(frame: view.frame, label: "Cargando")
    
    @IBOutlet weak var patientName: UILabel!
    
    @IBOutlet weak var patientBirthday: UILabel!
    
    @IBOutlet weak var patientImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMedicalRecord()
    }
    
    func getMedicalRecord() {
        activityIndicator.add(view: UIApplication.shared.keyWindow!)
        ApiClient.shared.getMedicalRecord(patientId: patient.id) { (result) in
            switch result {
            case let .success(medicalRecord):
                self.patient.medicalRecord = medicalRecord
                self.updateLayout()
            case let .error(error):
                self.alert(message: error, title: "Error")
            }
            self.activityIndicator.remove()
        }
    }
    
    func updateLayout() {
        patientName.text = patient.fullName
        patientBirthday.text = patient.birthDate?.toString(format: "dd/MMM/yyyy")
        if patient.gender == "M" {
            patientImage.image = UIImage(named: "avatar_boy")
        } else {
            patientImage.image = UIImage(named: "avatar_girl")
        }
        
    }
    
}
