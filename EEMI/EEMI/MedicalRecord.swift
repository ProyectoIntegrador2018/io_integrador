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
    var immunization = [Immunization]()
    
    init(json: JSON) {
        mother = json["mother"].stringValue
        father = json["father"].stringValue
        
//        let jsonAppointments = json["appointments"].arrayValue
//        for jsonAppointment in jsonAppointments {
//            appointments.append(Appointment(json: jsonAppointment))
//        }
        
    }
}

struct Immunization {
    var name: String
    var status: Int
}
