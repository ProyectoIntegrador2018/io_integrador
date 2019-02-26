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
        patientName = json["patientName"].string
        patientLastName = json["patientLastName"].string
        comments = json["comments"].string
        reason = json["reason"].string
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        date = dateFormatter.date(from: json["dateAppointment"].string ?? "")
    }
}
