//
//  AddAppointmentViewController.swift
//  EEMI
//
//  Created by Daniel on 4/22/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import FSCalendar

class AddAppointmentViewController: UIViewController, UITextViewDelegate {
    
    var patient: Patient!
    var selectedDay = Date()
    lazy var activityIndicator = ActivityIndicatorView(frame: view.frame, label: "Cargando")
    
    @IBOutlet weak var saveAppointmentBtn: UIButton!
    @IBOutlet weak var commentsTextView: UITextView!
    @IBOutlet weak var immunizationSwitch: UISwitch!
    @IBOutlet weak var appointmentScroll: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        commentsTextView.delegate = self
    }
    
    func layout() {
        addCustomBackButton(title: patient.fullName)
        KeyboardAvoiding.avoidingView = appointmentScroll
        saveAppointmentBtn.layer.cornerRadius = saveAppointmentBtn.frame.height/6
        immunizationSwitch.isOn = false
        commentsTextView.textColor = UIColor.lightGray
    }
    
    func addCustomBackButton(title: String) {
        let backButton = UIBarButtonItem()
        backButton.title = title
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    func alertMessage(message: String, title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: finishAlert)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
    }
    
    // MARK: - Actions
    
    @IBAction func saveAppointment(_ sender: Any) {
        self.view.endEditing(true)
        activityIndicator.add(view: UIApplication.shared.keyWindow!)
        var comments = ""
        
        if commentsTextView.textColor != UIColor.lightGray {
          comments = commentsTextView.text
        }
        
        let parameters: [String: Any] = [
            "idPatient": patient.id,
            "dateAppointment": selectedDay.iso8601,
            "timeAppointment": "08:00:00",
            "requiresImmunization": immunizationSwitch.isOn,
            "comments": comments
        ]
        
        ApiClient.shared.createAppointment(parameters: parameters) { (result) in
            self.activityIndicator.remove()
            switch result {
            case .success:
                self.alertMessage(message: "Cita agendada para el dia: \(self.selectedDay.toString(format: "dd/MM/yyyy"))",
                           title: "Cita creada")
            case let .error((message, title)):
                self.alertMessage(message: message, title: title)
            }
        }

    }
    
    @IBAction func toggleImmunization(_ sender: Any) {
        
    }
    
    func finishAlert(alert: UIAlertAction!) {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - TextView
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.textColor = UIColor.black
            textView.text = nil
        }
        
        let textViewY = commentsTextView.frame.minY-50
        appointmentScroll.setContentOffset(CGPoint(x: 0, y: textViewY), animated: true)
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.textColor = UIColor.lightGray
            textView.text = "Comentarios..."
        }
    }
    
}

extension AddAppointmentViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDay = date
    }
}
