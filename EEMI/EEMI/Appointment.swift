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
    var appointmentTime: Date?

    init(json: JSON) {
        self.patientName = json["patientName"].string
        self.patientLastName = json["patientLastName"].string
        self.comments = json["comments"].string
        self.reason = json["reason"].string
        self.appointmentTime = join(json: json)
    }

    private
    func join (json: JSON) -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"

        let date = json["dateAppointment"].string ?? "0000-00-00"
        let time = json["timeAppointment"].string ?? "00:00:00"
        var splitDate = date.split(separator: "T")

        let joinedDates = splitDate[0] + "'T'" + time
        return dateFormatter.date(from: joinedDates)!
    }
}
