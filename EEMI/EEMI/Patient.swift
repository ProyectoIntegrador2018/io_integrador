//
//  Patient.swift
//  EEMI
//
//  Created by Jorge Elizondo on 3/19/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import Foundation
import SwiftyJSON

class Patient {
    let id: Int
    let firstName: String
    let lastName: String
    let secondLastName: String
    let gender: String
    let birthDate: Date?
    
    var fullName: String {
        return self.firstName + " " + self.lastName + " " + self.secondLastName
    }
    
    init(json: JSON) {
        id = json["idPatient"].intValue
        firstName = json["firstName"].stringValue
        lastName = json["lastName"].stringValue
        secondLastName = json["lastName2"].stringValue
        gender = json["gender"].stringValue
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        birthDate = dateFormatter.date(from: json["birthDate"].stringValue)
    }
}
