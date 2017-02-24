//
//  NewReleasesRequest.swift
//  TVMed
//
//  Created by Vinicius Albino on 21/02/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

class NewReleasesRequest  {
    func request(callback: @escaping ([Release]?, ErrorTypeApp?) -> ()) {
        BaseRequest().GET(url: "congresso/lancamentos/pt-BR", params: [:]) { result, error, response in
            guard error == nil else {
                callback(nil, error)
                return
            }
            let result = result as? [JSONDictionary] <*> (Release.self, error)
            callback(result.object, result.error)
        }
    }
}
