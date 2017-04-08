//
//  CheckoutRequest.swift
//  TVMed
//
//  Created by Vinicius Albino on 03/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

class CheckoutRequest {
    
    func calculateShipping(state: String, quantity: Int,  callback: @escaping (Float, ErrorTypeApp?) -> ()) {
        let finalUrl = "pedido/valorfrete/\(state)/\(quantity)"
        HeaderBuilder().GET(url: finalUrl, params: [:]) { result, error, response in
            guard error == nil else {
                callback(0, error)
                return
            }
            if let frete = result?["valorFrete"] as? Float {
                callback(frete, nil)
            } else {
                callback(0, ErrorTypeApp.apiError)
            }
        }
    }
    
    func makePayment(cartParameters: JSONDictionary, callback: @escaping (CheckoutResponse?, ErrorTypeApp?) -> ()) {
        print(cartParameters)
        let params = cartParameters as [String: AnyObject]
        HeaderBuilder().buildHeader { defaultHeaders in
            BaseRequest().POST(url: "pedido/fecharpedido", params: params, headers: defaultHeaders, callback: { result, error, response in
                print("error \(error)")
                guard error == nil else {
                    callback(nil, error)
                    return
                }
                print("result \(result)")
                print("response \(response)")
                
                let result = result <*> (CheckoutResponse.self, error)
                callback(result.object, result.error)
            })
        }
    }
}
