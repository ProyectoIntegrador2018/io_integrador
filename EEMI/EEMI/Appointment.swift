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
    
    init(json: JSON) {
        self.patientName = json["patientName"].string
        self.patientLastName = json["patientLastName"].string
        self.comments = json["comments"].string
        self.reason = json["reason"].string
    }
}
