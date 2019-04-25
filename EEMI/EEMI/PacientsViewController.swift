//
//  PacientsViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit
import Presentr

class PacientsViewController: UIViewController {

    var patients = [Patient]()
    var currentPatients = [Patient]()
    var groupedPatients = [String: [Patient]]()
    var sections = [String]()
    lazy var activityIndicator = ActivityIndicatorView(frame: view.frame, label: "Cargando")
    var pinCodeView: PinCodeView!
    var pin = [Character]()

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var patientsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        getPatients()
    }

    func getPatients() {
        activityIndicator.add(view: UIApplication.shared.keyWindow!)
        ApiClient.shared.getPatients { (result) in
            switch result {
            case let .success(patients):
                self.patients = patients.sorted {$0.lastName < $1.lastName}
                self.groupedPatients = Dictionary(grouping: self.patients, by: {String($0.lastName.prefix(1))})
                self.sections = self.groupedPatients.keys.sorted()
                self.patientsTableView.reloadData()
            case let .error((message, title)):
                self.alert(message: message, title: title)
            }
            self.activityIndicator.remove()
        }
    }

    func attributedText(withString string: String, boldString: String, font: UIFont) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: string,
                                                         attributes: [NSAttributedString.Key.font: font])
        let boldFontAttribute: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: font.pointSize)]
        let range = (string as NSString).range(of: boldString)
        attributedString.addAttributes(boldFontAttribute, range: range)
        return attributedString
    }

}

// MARK: - Local Authorization

extension PacientsViewController: PinCodeDelegate {

    func didSelectForgotPin() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ForgotPinViewController") as! ForgotPinViewController
        let presenter: Presentr = {
            let width = ModalSize.fluid(percentage: 0.8)
            let height = ModalSize.fluid(percentage: 0.4)
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
        }
    }

    func didSelectDelete() {
        _ = pin.popLast()
    }
  }

extension PacientsViewController: UITableViewDataSource, UITableViewDelegate {

    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section]
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections.isEmpty {
            return 0
        }
        return groupedPatients[sections[section]]?.count ?? 0
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        view.endEditing(true)
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let section = sections[indexPath.section]
        let patients = groupedPatients[section]!
        let vc = storyboard?.instantiateViewController(withIdentifier: "PatientViewController") as! PatientViewController
        vc.patient = patients[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let section = sections[indexPath.section]
        let patients = groupedPatients[section]
        let patient = patients![index]

        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath)
        cell.textLabel?.attributedText = attributedText(withString: patient.fullName, boldString: patient.lastName, font: UIFont.systemFont(ofSize: 18))
        cell.selectionStyle = .none
        return cell
    }

}

extension PacientsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            currentPatients = patients
        } else {
            currentPatients = patients.filter { (patient) -> Bool in
                let name = patient.fullName.lowercased().folding(options: .diacriticInsensitive, locale: .current)
                let search = searchText.lowercased().folding(options: .diacriticInsensitive, locale: .current)
                return name.contains(search)
            }
        }

        self.groupedPatients = Dictionary(grouping: currentPatients, by: {String($0.lastName.prefix(1))})
        self.sections = self.groupedPatients.keys.sorted()
        self.patientsTableView.reloadData()
        patientsTableView.reloadData()
    }
}
