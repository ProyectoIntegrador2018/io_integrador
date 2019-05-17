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
import Presentr

class AgendaViewController: UIViewController, UIGestureRecognizerDelegate {

    @IBOutlet weak var calendar: FSCalendar!
    @IBOutlet weak var calendarHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var stateIndicatorView: StateIndicatorView!

    let agenda = Calendar.current
    var appointments = [String: [Appointment]]()
    var selectedDay = Date().toString()
    var pin = [Character]()
    let refreshButton = UIButton()
    let toggleAgenda = UIButton()
    var pinCodeView: PinCodeView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if User.shared.isAuthenticationOn {
            authenticateUser()
        }
 
        layout()
        getAppointments(interval: Date().interval(of: .year))
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    @objc func appWillEnterForeground() {
        pin.removeAll()
        pinCodeView.removeFromSuperview()
        pinCodeView = PinCodeView(frame: view.frame)
        pinCodeView.delegate = self
        tabBarController?.view.addSubview(pinCodeView)
        localAuthentication(fallbackView: pinCodeView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let barItemRefresh: UIBarButtonItem = UIBarButtonItem(customView: refreshButton)
        let barItemToggle: UIBarButtonItem = UIBarButtonItem(customView: toggleAgenda)
        
        navigationItem.leftBarButtonItem = barItemRefresh
        navigationItem.rightBarButtonItem = barItemToggle
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        navigationItem.leftBarButtonItem = nil
    }
    
    func authenticateUser() {
        NotificationCenter.default.addObserver(self, selector: #selector(appWillEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        pinCodeView = PinCodeView(frame: view.frame)
        pinCodeView.delegate = self
                
        tabBarController?.view.addSubview(pinCodeView)
        localAuthentication(fallbackView: pinCodeView)
        
    }

    // MARK: - Layout

    func layout() {
        refreshButton.setImage(UIImage(named: "refresh"), for: .normal)
        refreshButton.addTarget(self, action: #selector(refresh), for: .touchUpInside)
        
        toggleAgenda.setImage(UIImage(named: "toggle"), for: .normal)
        toggleAgenda.addTarget(self, action: #selector(toggle), for: .touchUpInside)
        
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

    @objc func toggle() {
        switch self.calendar.scope {
        case .month:
            calendar.setScope(.week, animated: true)
            toggleAgenda.flipDown()
        case .week:
            calendar.setScope(.month, animated: true)
            toggleAgenda.flipUp()
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

            case let .error((message, title)):
                if title == "Tú sesión expiro" {
                    self.sesionExpirationAlert(message: message, title: title)
                } else {
                    self.alert(message: message, title: title)
                }
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
            if velocity.y < 0 {
                toggleAgenda.flipDown()
            }
            return velocity.y < 0
        case .week:
            if velocity.y > 0 {
                toggleAgenda.flipUp()
            }
            toggleAgenda.flipUp()
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

        cell.selectionStyle = .none
        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(80)
    }

}

// MARK: - Local Authorization

extension AgendaViewController: PinCodeDelegate {
    func didSelectForgotPin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPinViewController") as! ForgotPinViewController
        let presenter: Presentr = {
            let width = ModalSize.fluid(percentage: 0.8)
            let height = ModalSize.fluid(percentage: 0.6)
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            let customPresenter = Presentr(presentationType: customType)
            return customPresenter
        }()
        self.customPresentViewController(presenter, viewController: vc, animated: true, completion: nil)
    }

    func didSelectButton(number: Int) {
       pin.append(Character(String(number)))
        if String(pin) == User.shared.pin {
            pinCodeView.removeFromSuperview()
            pin.removeAll()
        }
    }

    func didSelectDelete() {
        _ = pin.popLast()
    }
}
