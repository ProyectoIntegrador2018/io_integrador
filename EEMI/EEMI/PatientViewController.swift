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
    var isShowingRecords = true
    var addAppointmentButton = UIButton()
    lazy var activityIndicator: ActivityIndicatorView = ActivityIndicatorView(frame: view.frame, label: "Cargando")

    @IBOutlet weak var patientName: UILabel!
    @IBOutlet weak var patientBirthday: UILabel!
    @IBOutlet weak var patientImage: UIImageView!
    @IBOutlet weak var fatherLabel: UILabel!
    @IBOutlet weak var motherLabel: UILabel!
    @IBOutlet weak var recordButton: SegmentedControlButton!
    @IBOutlet weak var immunizationButton: SegmentedControlButton!
    @IBOutlet weak var patientTableView: UITableView!
    @IBOutlet weak var familyStackView: UIStackView!
    @IBOutlet weak var fatherStackView: UIStackView!
    @IBOutlet weak var motherStackView: UIStackView!
    @IBOutlet weak var stateIndicatorView: StateIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getMedicalRecord()
        defaultLayout()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        let barItemAddAppointment: UIBarButtonItem = UIBarButtonItem(customView: addAppointmentButton)

        navigationItem.rightBarButtonItem = barItemAddAppointment
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.rightBarButtonItem = nil
    }

    func getMedicalRecord() {
        activityIndicator.add(view: UIApplication.shared.keyWindow!)
        ApiClient.shared.getMedicalRecord(patientId: patient.id) { (result) in
            switch result {
            case let .success(medicalRecord):
                self.patient.medicalRecord = medicalRecord
                self.updateLayout()
            case let .error((message, title)):
                if title == "Tú sesión expiro" {
                    self.sesionExpirationAlert(message: message, title: title)
                } else {
                    self.alert(message: message, title: title)
                }
            }
            self.activityIndicator.remove()
        }
    }

    func updateLayout() {
        patientTableView.reloadData()
        if patient.medicalRecord?.father != "" {
            fatherStackView.isHidden = false
            fatherLabel.text = patient.medicalRecord?.father
        } else {
            fatherStackView.isHidden = true
        }

        if patient.medicalRecord?.mother != "" {
            motherStackView.isHidden = false
            motherLabel.text = patient.medicalRecord?.mother
        } else {
            motherStackView.isHidden = true
        }
    }

    func defaultLayout() {
        patientName.text = patient.fullName
        patientBirthday.text = patient.birthDate?.toString(format: "dd/MMM/yyyy")
        if patient.gender == "M" {
            patientImage.image = UIImage(named: "avatar_boy")
        } else {
            patientImage.image = UIImage(named: "avatar_girl")
        }

        addAppointmentButton.setTitle("Agendar", for: .normal)
        addAppointmentButton.setTitleColor(.white, for: .normal)
        addAppointmentButton.addTarget(self, action: #selector(addAppointment), for: .touchUpInside)

        stateIndicatorViewLayout(description: "Sin consultas registradas")
    }

    func stateIndicatorViewLayout(description: String) {
        stateIndicatorView.descriptionLabel.text = description
        stateIndicatorView.descriptionImage.image = UIImage(named: "logo_login")
    }

    @objc func addAppointment() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "AddAppointmentViewController") as! AddAppointmentViewController
        vc.patient = self.patient
        navigationController?.pushViewController(vc, animated: true)
    }

    @IBAction func showRecords(_ sender: UIButton) {
        isShowingRecords = true
        recordButton.selected()
        immunizationButton.unselected()
        patientTableView.reloadData()
    }

    @IBAction func showImmunization(_ sender: UIButton) {
        isShowingRecords = false
        immunizationButton.selected()
        recordButton.unselected()
        patientTableView.reloadData()
    }
}

extension PatientViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isShowingRecords {
            stateIndicatorViewLayout(description: "Sin consultas registradas")
            let summaries_count = patient.medicalRecord?.summaries.count ?? 0
            if summaries_count == 0 {
                stateIndicatorView.show()
            } else {
                stateIndicatorView.hide()
            }
            return summaries_count
        } else {
            stateIndicatorViewLayout(description: "Sin inmunizaciones registradas")
            let immunizations_count = patient.medicalRecord?.immunizations.count ?? 0
            if immunizations_count == 0 {
                stateIndicatorView.show()
            } else {
                stateIndicatorView.hide()
            }
            return immunizations_count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       let index = indexPath.row

        if isShowingRecords {
            let cell = tableView.dequeueReusableCell(withIdentifier: "RecordCell", for: indexPath)
            let summary = patient.medicalRecord?.summaries[index]
            cell.textLabel!.text = summary?.reason
            cell.detailTextLabel!.text = (summary?.date?.toString(format: "dd/MMM/yyyy") ?? "") + " - " + (summary?.description ?? "")
            cell.selectionStyle = .none
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "ImmunizationCell", for: indexPath) as! ImmunizationTableViewCell
            cell.titleLabel.text = patient.medicalRecord?.immunizations[index].name
            let status = patient.medicalRecord?.immunizations[index].status
            var statusImage: UIImage

            switch status {
            case -1:
                statusImage =  UIImage()
            case 0:
                statusImage = UIImage(named: "yellowdot") ?? UIImage()
            case 1:
                statusImage = UIImage(named: "reddot") ?? UIImage()
            case 2:
                statusImage = UIImage(named: "greendot") ?? UIImage()
            default:
                statusImage = UIImage()
            }

            cell.selectionStyle = .none
            cell.statusImageView.image = statusImage

            return cell
        }
    }
}
