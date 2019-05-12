//
//  ErrorClient.swift
//  EEMI
//
//  Created by Oscar Elizondo on 5/12/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import Foundation

class ErrorClient {
    let error: Error
    let statusCode: Int
    let source: String

    init(error: Error? = nil, statusCode: Int, source: String) {
        self.error = error!
        self.statusCode = statusCode
        self.source = source
    }
    
    func handleError() -> (String, String) {
        if self.error != nil && self.error._code == NSURLErrorNotConnectedToInternet {
            return self.noInternetError()
        } else if statusCode == 401 {
            return self.notFoundError()
        } else {
            return self.errorFromSource()
        }
    }
    
    func errorFromSource() -> (String, String) {
        switch self.source {
        case "getToken":
            return self.getTokenError()
        case "getAppointments":
            return self.getAppointmentError()
        case "getPatients":
            return self.getPatientsError()
        case "getMedicalRecord":
            return self.getMedicalRecordError()
        case "createAppointment":
            return self.createAppointmentError()
        default:
            return self.defaultError()
        }
    }
    
    func notFoundError() -> (String, String) {
        return ("Cierra la sesión y vuelve ingresar", "Tú sesión expiró.")
    }

    func noInternetError() -> (String, String) {
        return ("Inténtalo más tarde.", "No pudimos conectarnos a internet.")
    }
    
    func getTokenError() -> (String, String) {
        return ("Usuario o contraseña inválida.", "No se pudo iniciar sesión.")
    }
    
    func getAppointmentError() -> (String, String) {
        return ("Inténtalo más tarde.", "No se pudieron obtener citas.")
    }
    
    func getPatientsError() -> (String, String) {
        return ("Inténtalo más tarde.", "No se pudieron obtener los pacientes.")
    }
    
    func getMedicalRecordError() -> (String, String) {
        return ("Inténtalo más tarde.", "No se pudo obtener el expediente médico.")
    }
    
    func createAppointmentError() -> (String, String) {
        return ("Porfavor inténtalo más tarde", "No se pudo crear la cita.")
    }
    
    func defaultError() -> (String, String) {
        return ("Porfavor inténtalo más tarde", "Hubo un error.")
    }
}
