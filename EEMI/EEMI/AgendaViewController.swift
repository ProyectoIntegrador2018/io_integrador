//
//  AgendaViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import FSCalendar

class AgendaViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var monthAppointments = [String: [Appointment]]()
    var selectedDay = Date().toString()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getAppointments()
        calendarLayout()
        self.view.addGestureRecognizer(self.scopeGesture)
    }

    // MARK: - UIGestureRecognizerDelegate
    
    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()

    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {

        let velocity = self.scopeGesture.velocity(in: self.view)
        switch self.calendar.scope {
        case .month:
            return velocity.y < 0
        case .week:
            return velocity.y > 0
        }
    }

    // MARK: - API

    func getAppointments() {
        
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: Date()) else { return }
        
        ApiClient.shared.getAppointments(dateInterval: interval) { (result) in
            switch result {
            case let .success(appointments):
                print("Appointment count: " + String(appointments.count))
                for appointment in appointments {
                    if let key = appointment.date?.toString() {
                        if (self.monthAppointments[key]?.append(appointment)) == nil {
                            self.monthAppointments[key] = [appointment]
                        }
                    }
                }
                self.calendar.reloadData()
                self.tableView.reloadData()
            case let .error(error):
                print("Error: " + error.debugDescription)
            }
        }
    }

}

extension AgendaViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    func calendarLayout() {
        calendar.scope = .week
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDay = date.toString()
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let key = date.toString()
        return monthAppointments[key]?.count ?? 0
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
//        let key = date.toString()
//
//        if monthAppointments[key] != nil {
//            return ColorPallet.sumbitOrange
//        }
        
        return nil
    }

}

extension AgendaViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let appointments = monthAppointments[selectedDay] else {
            return 0
        }
        
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath)
        if let appointments = monthAppointments[selectedDay] {
            let appointment = appointments[indexPath.row]
            cell.textLabel?.text = appointment.patientName
            cell.detailTextLabel?.text = appointment.comments
        }
        return cell
    }

}
