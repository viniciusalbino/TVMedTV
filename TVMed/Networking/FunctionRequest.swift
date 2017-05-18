//
//  FunctionRequest.swift
//  TVMed
//
//  Created by Vinicius Albino on 17/05/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

class FunctionRequest {
    
    func getFunctionWorking(callback: @escaping (WorkResult?, ErrorTypeApp?) -> ()) {
        HeaderBuilder().GET(url: "appletv/authorization/status", params: [:]) { result, error, response in
            guard error == nil else {
                callback(nil, error)
                return
            }
            let result = result <*> (WorkResult.self, error)
            callback(result.object, result.error)
        }
    }
}
