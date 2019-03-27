//
//  UIApplicationExtension.swift
//  EEMI
//
//  Created by Jorge Elizondo on 3/26/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import Foundation

func isAppAlreadyLaunchedOnce() -> Bool {
    let defaults = UserDefaults.standard
    
    if defaults.string(forKey: "isAppAlreadyLaunchedOnce") != nil {
        return true
    } else {
        defaults.set(true, forKey: "isAppAlreadyLaunchedOnce")
        return false
    }
}
