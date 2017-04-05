//
//  CheckoutRequest.swift
//  TVMed
//
//  Created by Vinicius Albino on 03/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

class CheckoutRequest {
    
    func calculateShipping(state: String, quantity: Int,  callback: @escaping (Int, ErrorTypeApp?) -> ()) {
        let finalUrl = "pedido/valorfrete/\(state)/\(quantity)"
        HeaderBuilder().GET(url: finalUrl, params: [:]) { result, error, response in
            guard error == nil else {
                callback(0, error)
                return
            }
            if let frete = result?["valorFrete"] as? Int {
                callback(frete, nil)
            } else {
                callback(0, ErrorTypeApp.apiError)
            }
        }
    }
    
    func makePayment(cart: Cart, callback: @escaping (CheckoutResponse?, ErrorTypeApp?) -> ()) {
        HeaderBuilder().GET(url: "pedido/fecharpedido", params: cart.parameters()) { result, error, response in
            guard error == nil else {
                callback(nil, error)
                return
            }
            let result = result <*> (CheckoutResponse.self, error)
            callback(result.object, result.error)
        }
    }
}
