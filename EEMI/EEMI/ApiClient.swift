//
//  ApiClient.swift
//  EEMI
//
//  Created by Jorge Elizondo on 2/17/19.
//  Copyright © 2019 Io Labs. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

enum Result<T> {
    case success(T)
    case error(String)
}

class ApiClient {
    
    static let shared = ApiClient()
    
    private init() {}
    
    func getToken(username: String, password: String, completion: @escaping (Result<String>) -> Void ) {
        
        var url = "http://emmiapi.azurewebsites.net/api/Token?username=\(username)&password=\(password)"
        url = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        Alamofire.request(url).responseJSON { response in
            switch response.result {
            case .success:
                let data = response.data
                let json = try? JSON(data: data!)
                let token = json?["access_token"].stringValue
                completion(.success(token!))
            case .failure(let error):
                completion(.error(error.localizedDescription))
            }
        }
    }
}
