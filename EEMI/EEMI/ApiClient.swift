//
//  ApiClient.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Result<T> {
    case success(T)
    case error((String, String))
}

enum Endpoints {
    case getTokens(String, String)
    case getAppointments(String, String)
    case getPatients
    case getMedicalRecord(Int)
    
    func url() -> URL {
        var path: String
        let baseUrl = "https://eemimobile-apiqa.azurewebsites.net/api"
        
        switch self {
        case let .getTokens(username, password):
            path = "/Token?username=\(username)&password=\(password)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        case let .getAppointments(startDate, endDate):
            path = "/Agenda/GetByDate/\(startDate)/\(endDate)"
        case .getPatients:
            path = "/Patients"
        case let .getMedicalRecord(patientId):
            path = "/MedicalRecord/GetByPatientId/\(patientId)"
        }
        
        return URL(string: baseUrl + path)!
    }
}

class ApiClient {
    
    static let shared = ApiClient()
    
    private init() {}
    
    func getToken(username: String, password: String, completion: @escaping (Result<String>) -> Void ) {
        let loginUrl = Endpoints.getTokens(username, password).url()
        Alamofire.request(loginUrl).responseJSON { response in
            switch response.result {
            case let .success(value):
                let json = JSON(value)
                let token = json["access_token"].stringValue
                completion(.success(token))
                
            case let .failure(error):
                let statusCode = response.response?.statusCode
                let err = ErrorClient(error: error, statusCode: statusCode ?? 400, source: "getToken")
                completion(.error(err.handleError()))
            }
        }
    }
    
    func getAppointments(dateInterval: DateInterval, completion: @escaping (Result<[Appointment]>) -> Void ) {
        let startDate = dateInterval.start.toString()
        let endDate = dateInterval.end.toString()
        let appointmentUrl = Endpoints.getAppointments(startDate, endDate).url()
        let token = User.shared.token!
        let headers: HTTPHeaders = [
            "Authorization": ("Bearer " + token),
            "Accept": "application/json"
        ]
        
        Alamofire.request(appointmentUrl, headers: headers).responseJSON { response in
            switch response.result {
            case let .success(value):
                var appointments = [Appointment]()
                let json = JSON(value)
                guard let jsonAppointments = json.array else {
                    return completion(.success(appointments))
                }
                
                for jsonAppointment in jsonAppointments {
                    let appointment = Appointment(json: jsonAppointment)
                    appointments.append(appointment)
                }
                
                completion(.success(appointments))
                
            case let .failure(error):
                let statusCode = response.response?.statusCode
                let err = ErrorClient(error: error, statusCode: statusCode ?? 400, source: "getAppointments")
                completion(.error(err.handleError()))
            }
        }
    }
    
    func getPatients(completion: @escaping (Result<[Patient]>) -> Void) {
        let url = Endpoints.getPatients.url()
        let token = User.shared.token!
        let headers: HTTPHeaders = [
            "Authorization": ("Bearer " + token),
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                var patients = [Patient]()
                let json = JSON(value)
                guard let jsonPatients = json.array else {
                    return completion(.success(patients))
                }
                for jsonPatient in jsonPatients {
                    let patient = Patient(json: jsonPatient)
                    patients.append(patient)
                }
                completion(.success(patients))
                
            case let .failure(error):
                let statusCode = response.response?.statusCode
                let err = ErrorClient(error: error, statusCode: statusCode ?? 400, source: "getPatients")
                completion(.error(err.handleError()))
            }
        }
    }
    
    func getMedicalRecord(patientId: Int, completion: @escaping (Result<MedicalRecord>) -> Void) {
        let url = Endpoints.getMedicalRecord(patientId).url()
        let token = User.shared.token!
        let headers: HTTPHeaders = [
            "Authorization": ("Bearer " + token),
            "Accept": "application/json"
        ]
        
        Alamofire.request(url, headers: headers).responseJSON { (response) in
            switch response.result {
            case let .success(value):
                let jsonValue = JSON(value)
                let medicalRecord = MedicalRecord(json: jsonValue)
                
                completion(.success(medicalRecord))
                
            case let .failure(error):
                let statusCode = response.response?.statusCode
                let err = ErrorClient(error: error, statusCode: statusCode ?? 400, source: "getMedicalRecord")
                completion(.error(err.handleError()))
            }
        }
    }
}
