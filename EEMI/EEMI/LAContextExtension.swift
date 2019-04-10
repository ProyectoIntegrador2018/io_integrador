//
//  LAContextExtension.swift
//  EEMI
//
//  Created by Jorge Elizondo on 3/26/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import LocalAuthentication

extension LAContext {
    enum BiometricType: String {
        case none
        case touchID
        case faceID
    }
    
    var biometricType: BiometricType {
        var error: NSError?
        self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error)
        
        if #available(iOS 11.0, *) {
            switch self.biometryType {
            case .none:
                return .none
            case .touchID:
                return .touchID
            case .faceID:
                return .faceID
            }
        } else {
            return  self.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: nil) ? .touchID : .none
        }
    }
}
