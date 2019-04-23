//
//  AddAppointmentViewController.swift
//  EEMI
//
//  Created by Daniel on 4/22/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

class AddAppointmentViewController: UIViewController, UITextViewDelegate {
    
    var patient: Patient!
    
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
        saveAppointmentBtn.addDropShadow()
        immunizationSwitch.isOn = false
        commentsTextView.textColor = UIColor.lightGray
    }
    
    func addCustomBackButton(title: String) {
        let backButton = UIBarButtonItem()
        backButton.title = title
        navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
    }
    
    // MARK: - Actions
    
    @IBAction func saveAppointment(_ sender: Any) {
        self.view.endEditing(true)
    }
    
    @IBAction func toggleImmunization(_ sender: Any) {
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
