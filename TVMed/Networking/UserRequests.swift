//
//  UserRequests.swift
//  TVMed
//
//  Created by Vinicius Albino on 31/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

class UserRequests  {
    func requestUserData(callback: @escaping (User?, ErrorTypeApp?) -> ()) {
        HeaderBuilder().GET(url: "medico/meusdados", params: [:]) { result, error, response in
            guard error == nil else {
                callback(nil, error)
                return
            }
            
            let result = result <*> (User.self, error)
            callback(result.object, result.error)
        }
    }
}
