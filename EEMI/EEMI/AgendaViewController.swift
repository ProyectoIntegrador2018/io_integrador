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
    
    var appointments = [String: [Appointment]]()
    var selectedDay = Date().toString()
    
    let refreshButton: UIButton = UIButton()
   
    override func viewDidLoad() {
        super.viewDidLoad()
        layout()
        getMonthAppointments(date: Date())
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barItem: UIBarButtonItem = UIBarButtonItem(customView: refreshButton)
        tabBarController?.navigationItem.leftBarButtonItem = barItem
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        tabBarController?.navigationItem.leftBarButtonItem = nil
    }
    
    // MARK: - Layout
    
    func layout() {
        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        self.view.addGestureRecognizer(self.scopeGesture)
        calendarLayout()
    }
    
    func calendarLayout() {
        calendar.scope = .week
    }
    
    // MARK: - Actions
    
    @objc func refresh() {
        if refreshButton.isRotating() {
            refreshButton.stopRotate()
        } else {
            let date =  calendar.currentPage
            getMonthAppointments(date: date)
        }
    }
    
    // MARK: - API
    
    func getMonthAppointments(date: Date) {
        let calendar = Calendar.current
        guard let interval = calendar.dateInterval(of: .month, for: date) else { return }
        
        refreshButton.startRotate()
        ApiClient.shared.getAppointments(dateInterval: interval) { (result) in
            switch result {
            case let .success(appointments):
                for appointment in appointments {
                    if let key = appointment.date?.toString() {
                        if (self.appointments[key]?.append(appointment)) == nil {
                            self.appointments[key] = [appointment]
                        }
                    }
                }
                self.calendar.reloadData()
                self.tableView.reloadData()
            case let .error(error):
                print("Error: " + error.debugDescription)
            }
            self.refreshButton.stopRotate()
        }
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

}

extension AgendaViewController: FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDay = date.toString()
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
            getMonthAppointments(date: date)
        }
        tableView.reloadData()
    }
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let key = date.toString()
        return appointments[key]?.count ?? 0
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }
    
    func calendar(_ calendar: FSCalendar, appearance: FSCalendarAppearance, titleDefaultColorFor date: Date) -> UIColor? {
        return nil
    }
    
    func calendarCurrentPageDidChange(_ calendar: FSCalendar) {
         let date = calendar.currentPage
         getMonthAppointments(date: date)
    }

}

extension AgendaViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        guard let appointments = appointments[selectedDay] else {
            return 0
        }
        
        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath)
        if let appointments = appointments[selectedDay] {
            let appointment = appointments[indexPath.row]
            cell.textLabel?.text = appointment.patientName
            cell.detailTextLabel?.text = appointment.comments
        }
        return cell
    }

}
