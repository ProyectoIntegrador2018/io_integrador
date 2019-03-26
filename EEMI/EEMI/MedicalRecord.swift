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
    var summaries = [Summary]()
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
        
        let jsonSummaries = json["summary"].arrayValue
        for jsonSummary in jsonSummaries {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            let date = dateFormatter.date(from: jsonSummary["date"].stringValue)
            let reason = jsonSummary["reason"].stringValue
            let description = jsonSummary["summary"].stringValue
            summaries.append(Summary(date: date, reason: reason, description: description))
        }
        
    }
    
    struct Immunization {
        var name: String
        var status: Int
    }
    
    struct Summary {
        var date: Date?
        var reason: String
        var description: String
    }
}
