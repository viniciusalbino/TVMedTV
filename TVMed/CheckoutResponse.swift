//
//  CheckoutResponse.swift
//  TVMed
//
//  Created by Vinicius Albino on 03/04/17.
//  Copyright © 2017 tvMed. All rights reserved.
//

import Foundation

struct CheckoutResponse: Mappable {
    
    var email = ""
    
    init?(map: Map) {
        mapping(map: map)
    }
    
    init() {
        
    }
    
    func mapping(map: Map) {
        email <- map["email"]
    }
}
