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
    var name, lastName, lastName2, reason, comments: String
    
    init(json: [String: JSON]) {
        self.name = (json["patientName"]?.string)!
        self.lastName = (json["patientLastName"]?.string)!
        self.lastName2 = (json["patientLastName2"]?.string)!
        self.comments = (json["comments"]?.string)!
        self.reason = (json["reason"]?.string)!
    }
}
