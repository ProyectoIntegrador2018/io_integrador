//
//  PacientsViewController.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import UIKit

class PacientsViewController: UIViewController {
    
    var patients = [Patient]()
    var currentPatients = [Patient]()
    var groupedPatients = [String: [Patient]]()
    var sections = [String]()
    
    lazy var activityIndicator = ActivityIndicatorView(frame: view.frame, label: "Cargando")

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
                self.patients = patients
                self.groupedPatients = Dictionary(grouping: patients, by: {String($0.firstName.prefix(1))})
                self.sections = self.groupedPatients.keys.sorted()
                self.patientsTableView.reloadData()
            case .error:
                self.alert(message: "No se pudieron obtener los pacientes", title: "Error")
            }
            self.activityIndicator.remove()
        }
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
        let vc = storyboard?.instantiateViewController(withIdentifier: "PatientViewController") as! PatientViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        let section = sections[indexPath.section]
        let patients =  groupedPatients[section]
        let patient = patients![index]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "patientCell", for: indexPath)
        cell.textLabel?.text = patient.fullName
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
        
        self.groupedPatients = Dictionary(grouping: currentPatients, by: {String($0.firstName.prefix(1))})
        self.sections = self.groupedPatients.keys.sorted()
        self.patientsTableView.reloadData()
        patientsTableView.reloadData()
    }
}
