//
//  AgendaViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import LocalAuthentication
import FSCalendar

class AgendaViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stateIndicatorView: StateIndicatorView!

    var pinCodeView: PinCodeView!
    let agenda = Calendar.current
    var appointments = [String: [Appointment]]()
    var selectedDay = Date().toString()
    var pin = [Character]()

    let refreshButton: UIButton = UIButton()

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification ,
                                               object: nil)

        if User.shared.token != nil {
            pinCodeView = PinCodeView(frame: view.frame)
            tabBarController?.view.addSubview(pinCodeView)
            pinCodeView.delegate = self
            localAuthentication(fallbackView: pinCodeView)
        }

        layout()
        getAppointments(interval: Date().interval(of: .year))
    }

    @objc func appWillEnterForeground() {
        tabBarController?.view.addSubview(pinCodeView)
        localAuthentication(fallbackView: pinCodeView)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barItem: UIBarButtonItem = UIBarButtonItem(customView: refreshButton)
        navigationItem.leftBarButtonItem = barItem
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.leftBarButtonItem = nil
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
        calendar.locale = Locale(identifier: "ES")
    }

    // MARK: - Actions

    @objc func refresh() {
        if refreshButton.isRotating() {
            refreshButton.stopRotate()
        } else {
            let date = calendar.currentPage
            getAppointments(interval: date.interval(of: .month))
        }
    }

    // MARK: - API

    func getAppointments(interval: DateInterval) {
        refreshButton.startRotate()
        ApiClient.shared.getAppointments(dateInterval: interval) { (result) in
            switch result {
            case let .success(appointments):
                var auxDict = [String: [Appointment]]()
                for appointment in appointments {
                    if let key = appointment.date?.toString() {
                        if (auxDict[key]?.append(appointment)) == nil {
                            auxDict[key] = [appointment]
                        }
                    }
                }
                self.appointments.merge(auxDict) {$1}
                self.calendar.reloadData()
                self.tableView.reloadData()

            case .error:
                self.alert(message: "No se pudieron obtener citas", title: "Error")
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
            getAppointments(interval: date.interval(of: .month))
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
        switch self.calendar.scope {
        case .month:
            getAppointments(interval: date.interval(of: .month))
        case .week:
            getAppointments(interval: date.interval(of: .weekOfMonth))
        }

    }

}

extension AgendaViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        guard let appointments = appointments[selectedDay] else {
            stateIndicatorView.show()
            return 0
        }
        stateIndicatorView.hide()

        return appointments.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "appointmentCell", for: indexPath) as! AppointmentTableViewCell
        if let appointments = appointments[selectedDay] {
            let appointment = appointments[indexPath.row]
            cell.titleLabel.text = "\(appointment.patientName ?? "") \(appointment.patientLastName ?? "")"
            cell.subtitleLabel.text = appointment.comments
            cell.timeLabel.text = appointment.date?.toString(format: "h:mm a")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)

    }

}

// MARK: - Local Authorization

extension AgendaViewController: PinCodeDelegate {
    func didSelectButton(number: Int) {
        pin.append(Character(String(number)))
        if String(pin) == User.shared.pin {
            pinCodeView.removeFromSuperview()
        }
    }

    func didSelectDelete() {
        _ = pin.popLast()
    }
}
