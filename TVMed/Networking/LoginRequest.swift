//
//  LoginRequest.swift
//  TVMed
//
//  Created by Vinicius Albino on 22/03/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

class LoginRequest {
    
    private let persister = TokenPersister()
    
    func request(loginDTO: LoginDTO, callback: @escaping (UserToken?, ErrorTypeApp?) -> ()) {
        BaseRequest().POST(url: "login", params: loginDTO.parameters()) { result, error, response in
            
            guard error == nil else {
                callback(nil, error)
                return
            }
            let result = result <*> (UserToken.self, error)
            if let token = result.object {
                self.persister.saveToken(token: token, callback: { success in
                    guard success else  {
                        callback(nil, ErrorTypeApp.forced)
                        return
                    }
                    callback(token, nil)
                })
            } else  {
                callback(nil, result.error)
            }
        }
    }
}
