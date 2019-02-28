//
//  Appointment.swift
//  EEMI
//
//  Created by Oscar Elizondo on 2/20/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Appointment {
    var patientName: String?
    var patientLastName: String?
    var reason: String?
    var comments: String?
    var date: Date?
    
    init(json: JSON) {
        self.patientName = json["patientName"].string
        self.patientLastName = json["patientLastName"].string
        self.comments = json["comments"].string
        self.reason = json["reason"].string
        self.date = join(json: json)
    }

    private func join (json: JSON) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyyHH:mm:ss"
        
        var dateAppointment = json["dateAppointment"].string ?? ""
        let timeAppointment = json["timeAppointment"].string ?? ""
        
        let split = dateAppointment.split(separator: " ")
        dateAppointment = String(split.first ?? "")
        let fullDateString = dateAppointment + timeAppointment
        
        return dateFormatter.date(from: fullDateString)
    }
}
