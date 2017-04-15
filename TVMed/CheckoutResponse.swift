//
//  CheckoutResponse.swift
//  TVMed
//
//  Created by Vinicius Albino on 03/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation
import ObjectMapper

struct CheckoutResponse: Mappable {
    
    var codigoPedido = ""
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
        
    }
    
    mutating func mapping(map: Map) {
        codigoPedido <- map["codigoPedido"]
    }
}
