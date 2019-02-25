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

    fileprivate lazy var scopeGesture: UIPanGestureRecognizer = {
        [unowned self] in
        let panGesture = UIPanGestureRecognizer(target: self.calendar, action: #selector(self.calendar.handleScopeGesture(_:)))
        panGesture.delegate = self
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        return panGesture
        }()

    override func viewDidLoad() {
        super.viewDidLoad()
        calendarLayout()
        self.view.addGestureRecognizer(self.scopeGesture)
    }

    // MARK: - UIGestureRecognizerDelegate

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

extension AgendaViewController: FSCalendarDataSource, FSCalendarDelegate {

    func calendarLayout() {
        calendar.scope = .week
    }

    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        if monthPosition == .next || monthPosition == .previous {
            calendar.setCurrentPage(date, animated: true)
        }
    }

    func calendar(_ calendar: FSCalendar, boundingRectWillChange bounds: CGRect, animated: Bool) {
        calendarHeightConstraint.constant = bounds.height
        self.view.layoutIfNeeded()
    }

}

extension AgendaViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath)
        return cell
    }

}
