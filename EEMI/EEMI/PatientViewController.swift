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
    @IBOutlet weak var fatherLabel: UILabel!
    @IBOutlet weak var motherLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var immunizationButton: UIButton!
    @IBOutlet weak var patientTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getMedicalRecord()
        defaultLayout()
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
        patientTableView.reloadData()
        patientName.text = patient.fullName
        patientBirthday.text = patient.birthDate?.toString(format: "dd/MMM/yyyy")
        fatherLabel.text = patient.medicalRecord?.father
        motherLabel.text = patient.medicalRecord?.mother
    }

    func defaultLayout() {
        immunizationButton.isEnabled = false
        if patient.gender == "M" {
            patientImage.image = UIImage(named: "avatar_boy")
        } else {
            patientImage.image = UIImage(named: "avatar_girl")
        }
    }

    @IBAction func showRecords(_ sender: UIButton) {
    }
    
    @IBAction func showImmunization(_ sender: UIButton) {
    }
}

extension PatientViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return patient.medicalRecord?.appointments.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
        cell.textLabel!.text = patient.medicalRecord?.appointments[indexPath.row].status
        cell.detailTextLabel!.text = patient.medicalRecord?.appointments[indexPath.row].date?.toString(format: "dd/MMM/yyyy")
        return cell
    }
}
