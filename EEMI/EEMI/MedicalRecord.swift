//
//  MedicalRecord.swift
//  EEMI
//
//  Created by Pablo Cantu on 3/20/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class MedicalRecord {
    let mother: String
    let father: String
    var appointments = [Appointment]()
    var immunizations = [Immunization]()
    
    init(json: JSON) {
        mother = json["mother"].stringValue
        father = json["father"].stringValue
        
        let jsonImmunizations = json["immunizations"].arrayValue
        for jsonImmunization in jsonImmunizations {
            let name = jsonImmunization["immunization"].stringValue
            let status = jsonImmunization["status"].intValue
            immunizations.append(Immunization(name: name, status: status))
        }
        
        let jsonAppointments = json["appointments"].arrayValue
        for jsonAppointment in jsonAppointments {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: jsonAppointment["date"].stringValue)
            let status = jsonAppointment["status"].stringValue
            appointments.append(Appointment(date: date, status: status))
        }
        
    }
    
    struct Immunization {
        var name: String
        var status: Int
    }
    
    struct Appointment {
        var date: Date?
        var status: String
    }
}
